import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// Auto-loaded by `flutter test` for every test under `test/`.
///
/// Golden (pixel) tests are host-rasterizer-sensitive: Skia anti-aliasing and
/// text shaping differ across operating systems, so a golden generated on one
/// platform shows a small (~2%) diff on another even with the font vendored.
/// We therefore pick **Linux as the single canonical platform** — it matches
/// both the `flutter` dev distrobox and the `test` CI job (ubuntu), which share
/// the same prebuilt `linux-x64` engine and so rasterize identically.
///
/// On any other host (e.g. a dev's Windows machine) golden *comparison* is
/// skipped so `flutter test` stays green; every non-golden test still runs.
/// Regenerate the goldens on Linux after intentional UI changes:
///   flutter test --update-goldens test/golden
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (!Platform.isLinux) {
    goldenFileComparator = _SkipGoldenComparator();
  }
  await testMain();
}

/// A no-op comparator: treats every golden as a match and never writes. Used off
/// the canonical platform so goldens are neither falsely failed nor regenerated
/// from a non-canonical rasterizer.
class _SkipGoldenComparator extends GoldenFileComparator {
  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async => true;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {}
}
