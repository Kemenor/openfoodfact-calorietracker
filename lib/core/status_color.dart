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
