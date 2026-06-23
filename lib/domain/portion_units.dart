import '../l10n/app_localizations.dart';

/// Localized word for a curated natural-portion unit key (see tool/portions/).
/// Unknown keys (e.g. a free-text serving label from a custom food) pass
/// through unchanged so they still display sensibly.
String portionUnitLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'piece':
      return l10n.portionUnitPiece;
    case 'medium':
      return l10n.portionUnitMedium;
    case 'slice':
      return l10n.portionUnitSlice;
    case 'clove':
      return l10n.portionUnitClove;
    case 'stalk':
      return l10n.portionUnitStalk;
    case 'handful':
      return l10n.portionUnitHandful;
    case 'cob':
      return l10n.portionUnitCob;
    default:
      return key;
  }
}
