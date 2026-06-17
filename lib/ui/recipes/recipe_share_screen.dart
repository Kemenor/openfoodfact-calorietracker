import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/recipe_share.dart';

/// Shows a scannable QR for the recipe plus a text/file share fallback.
/// Fully serverless — the QR/payload is self-contained (calories + macros).
class RecipeShareScreen extends StatelessWidget {
  final RecipeShare share;
  const RecipeShareScreen({super.key, required this.share});

  @override
  Widget build(BuildContext context) {
    final payload = RecipeCodec.encode(share);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Share "${share.name}"')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: payload,
                  version: QrVersions.auto,
                  size: 260,
                  // ignore: deprecated_member_use
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(share.name, style: theme.textTheme.titleMedium),
              Text(
                '${share.items.length} ingredients · '
                '${share.servings.toStringAsFixed(0)} servings · '
                '${payload.length} bytes',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Scan this in another phone’s "Import from QR".',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: () => SharePlus.instance.share(
                  ShareParams(
                    text: payload,
                    subject: 'Recipe: ${share.name}',
                  ),
                ),
                icon: const Icon(Icons.share),
                label: const Text('Share as text'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
