import 'package:calorie_tracker/data/db/database.dart';
import 'package:calorie_tracker/domain/offline_manifest.dart';
import 'package:calorie_tracker/l10n/app_localizations.dart';
import 'package:calorie_tracker/providers.dart';
import 'package:calorie_tracker/ui/settings/offline_regions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

OfflineManifest _manifest() => OfflineManifest.fromJson({
  'baseUrl': 'https://example/resolve/main',
  'attribution': 'Data from Open Food Facts, ODbL.',
  'regions': [
    {
      'code': 'ch',
      'name': 'Switzerland',
      'country_tag': 'en:switzerland',
      'version': '1',
      'products': 1,
      'file': 'packs/ch/region_ch.sqlite.gz',
      'size': 1,
      'sha256': 'a',
    },
    {
      'code': 'fr',
      'name': 'France',
      'country_tag': 'en:france',
      'version': '1',
      'products': 1,
      'file': 'packs/fr/region_fr.sqlite.gz',
      'size': 1,
      'sha256': 'b',
    },
  ],
});

Future<void> _pump(WidgetTester tester, {String? initialCountryTag}) {
  return tester.pumpWidget(
    ProviderScope(
      overrides: [
        offlineManifestProvider.overrideWith((ref) async => _manifest()),
        installedPacksProvider.overrideWith(
          (ref) => Stream.value(const <InstalledPack>[]),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OfflineRegionsScreen(initialCountryTag: initialCountryTag),
      ),
    ),
  );
}

void main() {
  testWidgets('deep-link pre-fills the search box and filters to the country', (
    tester,
  ) async {
    await _pump(tester, initialCountryTag: 'en:switzerland');
    await tester.pumpAndSettle();

    // Search box carries the matched region's name...
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, 'Switzerland');
    // ...and only that region's tile is listed.
    expect(find.text('Switzerland'), findsWidgets);
    expect(find.text('France'), findsNothing);
  });

  testWidgets('no tag shows every region with an empty search box', (
    tester,
  ) async {
    await _pump(tester);
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
    expect(find.text('Switzerland'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
  });

  testWidgets('an unknown tag falls back to the full, unfiltered list', (
    tester,
  ) async {
    await _pump(tester, initialCountryTag: 'en:atlantis');
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text, isEmpty);
    expect(find.text('Switzerland'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
  });
}
