/// Per-100 g nutrition values parsed from an OCR'd nutrition table.
class NutritionLabel {
  double? kcal100;
  double? protein100;
  double? carb100;
  double? fat100;
  double? fiber100;
  double? sugar100;
  double? satFat100;
  double? saltG100;

  bool get hasAny =>
      kcal100 != null ||
      protein100 != null ||
      carb100 != null ||
      fat100 != null;
}

// Keyword sets (lowercased substrings) for DE / FR / IT / EN labels. More
// specific rows (saturates, sugars) are tested before their parents (fat,
// carbs) so "of which sugars" doesn't get read as carbohydrate.
const _energy = ['energie', 'énergie', 'energy', 'energia', 'brennwert'];
const _satFat = ['gesättigt', 'satur', 'saturé', 'saturi'];
const _fat = ['fett', 'matières grasses', 'matieres grasses', 'lipides', 'fat', 'grassi'];
const _fiber = ['ballaststoffe', 'fibres', 'fibre', 'fiber'];
const _sugar = ['zucker', 'sucres', 'sugars', 'zuccheri'];
const _carb = ['kohlenhydrate', 'glucides', 'carbohydrate', 'carboidrati'];
const _protein = ['eiweiß', 'eiweiss', 'protéines', 'proteines', 'protein', 'proteine'];
const _salt = ['salz', 'sel', 'salt', 'sale'];

bool _has(String line, List<String> keys) => keys.any(line.contains);

final _numRe = RegExp(r'(\d+(?:[.,]\d+)?)');
final _kcalRe = RegExp(r'(\d+(?:[.,]\d+)?)\s*kcal');
final _kjRe = RegExp(r'(\d+(?:[.,]\d+)?)\s*kj');

double? _num(String s) {
  final m = _numRe.firstMatch(s);
  return m == null ? null : double.tryParse(m.group(1)!.replaceAll(',', '.'));
}

double? _energyKcal(String line) {
  final k = _kcalRe.firstMatch(line);
  if (k != null) return double.tryParse(k.group(1)!.replaceAll(',', '.'));
  final j = _kjRe.firstMatch(line);
  if (j != null) {
    final kj = double.tryParse(j.group(1)!.replaceAll(',', '.'));
    return kj == null ? null : (kj / 4.184); // kJ -> kcal
  }
  return null;
}

/// Parse OCR lines from a nutrition table into per-100 g values. Best-effort:
/// the user reviews/edits before saving.
NutritionLabel parseNutritionLabel(Iterable<String> lines) {
  final out = NutritionLabel();
  for (final raw in lines) {
    final line = raw.toLowerCase().trim();
    if (line.isEmpty) continue;

    if (out.kcal100 == null && _has(line, _energy)) {
      out.kcal100 = _energyKcal(line);
    } else if (out.satFat100 == null && _has(line, _satFat)) {
      out.satFat100 = _num(line);
    } else if (out.sugar100 == null && _has(line, _sugar)) {
      out.sugar100 = _num(line);
    } else if (out.fiber100 == null && _has(line, _fiber)) {
      out.fiber100 = _num(line);
    } else if (out.fat100 == null && _has(line, _fat)) {
      out.fat100 = _num(line);
    } else if (out.carb100 == null && _has(line, _carb)) {
      out.carb100 = _num(line);
    } else if (out.protein100 == null && _has(line, _protein)) {
      out.protein100 = _num(line);
    } else if (out.saltG100 == null && _has(line, _salt)) {
      out.saltG100 = _num(line);
    }
  }
  return out;
}
