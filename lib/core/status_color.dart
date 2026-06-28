import 'package:flutter/material.dart';
import 'package:fuchsbau/fuchsbau.dart';

import '../domain/day_summary.dart';

/// Canonical colour for a calorie/macro [TargetStatus] (single source for the
/// day screen + trends charts; see DESIGN_SYSTEM.md).
///
/// Fuchsbau ethos — *status is information, never punishment; red is for
/// destruction only*. The states map onto the triad: **under → indigo
/// (`secondary`, focus — working toward the goal)**, **in-range → emerald
/// (`tertiary`, achieved)**, **over → amber** (the one calm nudge — past the
/// max), **none → muted**. No red anywhere.
Color statusColor(BuildContext context, TargetStatus status) {
  final scheme = Theme.of(context).colorScheme;
  final amber = FuchsbauStatusColors.of(context).amber;
  return switch (status) {
    TargetStatus.over => amber,
    TargetStatus.under => scheme.secondary,
    TargetStatus.inRange => scheme.tertiary,
    TargetStatus.none => scheme.outline,
  };
}

/// AA-compliant colour for status used as **text** (WCAG 1.4.3, 4.5:1). The
/// bright [statusColor] is right for bars/dots/icons but several brand hues fail
/// as small text on the light surfaces — so in light mode text uses darker
/// shades; dark mode's brighter palette already passes on the dark surface.
Color statusTextColor(BuildContext context, TargetStatus status) {
  final theme = Theme.of(context);
  if (theme.brightness == Brightness.dark) return statusColor(context, status);
  return switch (status) {
    TargetStatus.over => const Color(0xFF9A6B12), // deep amber/ochre ≈4.6:1
    TargetStatus.under => const Color(0xFF6E45BB), // deep indigo ≈4.7:1
    TargetStatus.inRange => const Color(0xFF157A43), // deep emerald ≈4.6:1
    TargetStatus.none => theme.colorScheme.onSurfaceVariant,
  };
}
