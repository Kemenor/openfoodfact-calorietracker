import 'package:flutter/material.dart';
import 'package:fuchsbau/fuchsbau.dart';

import '../domain/day_summary.dart';

/// Canonical colour for a calorie/macro [TargetStatus] (single source for the
/// day screen + trends charts; see DESIGN_SYSTEM.md).
///
/// Fuchsbau ethos — *status is information, never punishment; red is for
/// destruction only*. So: **in-range → emerald** (positive/achieved),
/// **off-target either way (over or under) → amber** (a calm nudge, not a
/// scold), **none → muted**. Direction (over vs under) is conveyed by the bar
/// fill + the numeric value, so no red is needed.
Color statusColor(BuildContext context, TargetStatus status) {
  final scheme = Theme.of(context).colorScheme;
  final amber = FuchsbauStatusColors.of(context).amber;
  return switch (status) {
    TargetStatus.over => amber,
    TargetStatus.under => amber,
    TargetStatus.inRange => scheme.tertiary,
    TargetStatus.none => scheme.outline,
  };
}
