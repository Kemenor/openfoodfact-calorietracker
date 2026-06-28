import 'package:flutter/material.dart';
import 'package:fuchsbau/fuchsbau.dart';

/// App theme — delegates to the shared **fuchsbau** design system (the pinned
/// tangerine triad, replacing the old accidental-green M3 seed). knabberfuchs's
/// own component tweaks layer on top here; record any deviation in
/// `DESIGN_SYSTEM.md` with a pointer back to fuchsbau.
ThemeData buildTheme(Brightness brightness) => fuchsbauTheme(brightness);
