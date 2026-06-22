import 'dart:ui' show PlatformDispatcher;

/// UI locales the app ships strings for.
const supportedLocaleCodes = {'en', 'de', 'fr', 'it'};

/// Resolve the active UI locale code the way `MaterialApp` does: an explicit
/// `appLocale` setting wins if supported; otherwise the device locale if it's
/// one we ship; otherwise English. [explicit] is the stored setting
/// (`'en'`/`'de'`/`'fr'`/`'it'`, or null/`'system'` to follow the device).
///
/// Usable outside the widget tree (e.g. data-layer providers that have no
/// BuildContext) — inside widgets prefer `Localizations.localeOf(context)`.
String resolveUiLocale(String? explicit) {
  if (explicit != null && supportedLocaleCodes.contains(explicit)) {
    return explicit;
  }
  final device = PlatformDispatcher.instance.locale.languageCode;
  return supportedLocaleCodes.contains(device) ? device : 'en';
}
