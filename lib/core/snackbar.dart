import 'dart:async';

import 'package:flutter/material.dart';

extension AutoDismissSnackBar on ScaffoldMessengerState {
  /// Like [showSnackBar], but accessible and reliably auto-dismissing.
  ///
  /// - **Announces** the message to screen readers (WCAG 4.1.3): the content is
  ///   wrapped in a live region, since Material SnackBars aren't live regions and
  ///   status/error feedback would otherwise be silent for TalkBack/VoiceOver.
  /// - **Respects assistive tech for timing** (WCAG 2.2.1): when an a11y service
  ///   is active Flutter keeps SnackBars open so they can be read — we don't
  ///   force-close on those users; everyone else gets the normal auto-dismiss.
  ///
  /// Callers only ever set `content`, so reconstructing the SnackBar with a
  /// wrapped content (preserving its duration) is lossless here.
  void showAutoSnackBar(SnackBar snackBar) {
    final accessible = SnackBar(
      content: Semantics(liveRegion: true, child: snackBar.content),
      duration: snackBar.duration,
    );
    final controller = showSnackBar(accessible);
    final atActive = WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.accessibleNavigation;
    if (atActive) return; // leave it open for screen-reader users
    var closed = false;
    controller.closed.then((_) => closed = true);
    Timer(accessible.duration, () {
      if (!closed) controller.close();
    });
  }
}
