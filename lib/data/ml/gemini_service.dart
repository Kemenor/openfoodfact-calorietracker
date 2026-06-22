import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

/// One food estimate from Gemini — totals for the portion shown (not per 100 g).
class GeminiFoodResult {
  final String name;
  final double? grams;
  final double kcal;
  final double? protein;
  final double? carb;
  final double? fat;
  const GeminiFoodResult({
    required this.name,
    this.grams,
    required this.kcal,
    this.protein,
    this.carb,
    this.fat,
  });
}

/// Optional cloud food recognition via the user's own (free-tier) Google Gemini
/// API key. Sends the photo to Gemini and asks for the dish + nutrition as JSON.
/// Strictly opt-in: the on-device classifier stays the keyless default, and the
/// photo only leaves the device when the user has configured a key.
class GeminiService {
  // Latest free-tier Flash model (better at vision than 2.5). If Google
  // retires/renames it, the recognise flow falls back to the on-device
  // classifier — bump this string to follow the current model.
  static const _model = 'gemini-3.5-flash';
  static const _base =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static const _prompt =
      'You are a nutrition assistant. Identify the food in this photo and '
      'estimate the nutrition for the portion shown. Return the dish name, the '
      'estimated edible weight in grams, and the TOTALS for the whole portion '
      '(not per 100 g): calories in kcal, and protein, carbohydrate and fat in '
      'grams. If the image is not food, set is_food to false.';

  final http.Client _client;
  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  Future<GeminiFoodResult?> recognizeFood(Uint8List bytes, String apiKey) async {
    final b64 = base64Encode(_downscaleJpeg(bytes));
    final uri = Uri.parse('$_base/$_model:generateContent?key=$apiKey');
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': _prompt},
            {
              'inline_data': {'mime_type': 'image/jpeg', 'data': b64}
            },
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'responseMimeType': 'application/json',
        'responseSchema': {
          'type': 'object',
          'properties': {
            'is_food': {'type': 'boolean'},
            'name': {'type': 'string'},
            'grams': {'type': 'number'},
            'kcal': {'type': 'number'},
            'protein_g': {'type': 'number'},
            'carb_g': {'type': 'number'},
            'fat_g': {'type': 'number'},
          },
          'required': ['is_food', 'name', 'kcal'],
        },
      },
    });
    final resp = await _client
        .post(uri,
            headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 30));
    if (resp.statusCode != 200) return null;
    return parseGeminiResponse(resp.body);
  }

  /// Shrink the photo (longest side ≤ 768 px, JPEG q85) to keep the upload
  /// small and fast — plenty of detail for recognition.
  Uint8List _downscaleJpeg(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;
    var im = decoded;
    final maxSide =
        decoded.width >= decoded.height ? decoded.width : decoded.height;
    if (maxSide > 768) {
      im = decoded.width >= decoded.height
          ? img.copyResize(decoded, width: 768)
          : img.copyResize(decoded, height: 768);
    }
    return img.encodeJpg(im, quality: 85);
  }

  void dispose() => _client.close();
}

/// Parse Gemini's `generateContent` response into a [GeminiFoodResult].
/// Returns null on any shape mismatch or a non-food / nameless result.
GeminiFoodResult? parseGeminiResponse(String responseBody) {
  try {
    final data = jsonDecode(responseBody) as Map<String, dynamic>;
    final text = (((data['candidates'] as List?)?.first
            as Map<String, dynamic>?)?['content']?['parts'] as List?)
        ?.first?['text'] as String?;
    if (text == null) return null;
    final j = jsonDecode(text) as Map<String, dynamic>;
    if (j['is_food'] == false) return null;
    final name = (j['name'] as String?)?.trim();
    if (name == null || name.isEmpty) return null;
    double? n(dynamic v) => v is num ? v.toDouble() : null;
    final kcal = n(j['kcal']);
    if (kcal == null) return null;
    return GeminiFoodResult(
      name: name,
      grams: n(j['grams']),
      kcal: kcal,
      protein: n(j['protein_g']),
      carb: n(j['carb_g']),
      fat: n(j['fat_g']),
    );
  } catch (_) {
    return null;
  }
}
