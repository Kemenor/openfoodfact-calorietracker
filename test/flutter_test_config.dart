import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter_test/flutter_test.dart';

/// Auto-loaded by `flutter test` for every test under `test/`.
///
/// Golden (pixel) tests are host-rasterizer-sensitive. Two layers of policy:
///
///  * **Off Linux** (e.g. a dev's Windows machine) golden *comparison* is
///    skipped entirely — text shaping/AA differs by ~2% across OSes, which is
///    noise, not a regression. `flutter test` stays green; non-golden tests
///    still run. Linux is the canonical platform (the `flutter` dev distrobox +
///    the `test` CI job, both ubuntu/linux-x64).
///  * **On Linux** comparison runs, but with a small [_kGoldenTolerance].
///    Even two Linux machines on the same engine differ by a sub-pixel hair
///    (measured: 0.05%–0.24% between the Fedora distrobox and the GitHub ubuntu
///    runner on the largest charts — CPU-level float rounding in anti-aliasing).
///    0.5% absorbs that while staying far below any genuine UI change (the
///    Flutter 3.44.2→3.44.4 engine bump shifted these same goldens ~2%).
///
/// Regenerate the goldens on Linux after intentional UI changes:
///   flutter test --update-goldens test/golden
const double _kGoldenTolerance = 0.005; // 0.5%

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  if (Platform.isLinux) {
    final current = goldenFileComparator;
    if (current is LocalFileComparator) {
      goldenFileComparator = _TolerantComparator(
        current.basedir,
        _kGoldenTolerance,
      );
    }
  } else {
    goldenFileComparator = _SkipGoldenComparator();
  }
  await testMain();
}

/// Like [LocalFileComparator] but passes when the pixel diff is within
/// [threshold] — soaks up cross-machine sub-pixel AA noise on Linux.
class _TolerantComparator extends LocalFileComparator {
  _TolerantComparator(Uri basedir, this.threshold)
    : super(basedir.resolve('flutter_test_config.dart'));

  final double threshold;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= threshold) return true;
    throw FlutterError(await generateFailureOutput(result, golden, basedir));
  }
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
