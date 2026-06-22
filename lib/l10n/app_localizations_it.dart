// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Knabberfuchs';

  @override
  String get navDay => 'Giorno';

  @override
  String get navRecipes => 'Ricette';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get actionSave => 'Salva';

  @override
  String get actionCancel => 'Annulla';

  @override
  String get actionDelete => 'Elimina';

  @override
  String get actionAdd => 'Aggiungi';

  @override
  String get actionImport => 'Importa';

  @override
  String get settingsSectionLanguage => 'Lingua';

  @override
  String get settingsLanguage => 'Lingua dell’app';

  @override
  String get languageSystem => 'Predefinito di sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get dayPreviousDay => 'Previous day';

  @override
  String get dayNextDay => 'Next day';

  @override
  String get dayAddFood => 'Add food';

  @override
  String get dayMealFromList => 'Meal from an ingredient list';

  @override
  String get dayEmptyHint =>
      'Tap + to start a meal.\nEverything you add flows into it until you tap ✓ (or 15 min pass).';

  @override
  String get unitKcal => 'kcal';

  @override
  String get macroProtein => 'Protein';

  @override
  String get macroCarbs => 'Carbs';

  @override
  String get macroFat => 'Fat';

  @override
  String targetOver(String kcal) {
    return '$kcal over';
  }

  @override
  String targetToGo(String kcal) {
    return '$kcal to go';
  }

  @override
  String targetLeft(String kcal) {
    return '$kcal left';
  }

  @override
  String get targetMinReached => 'minimum reached';

  @override
  String targetRangeBoth(String min, String max) {
    return 'Target $min–$max kcal';
  }

  @override
  String targetRangeMax(String max) {
    return 'Target $max kcal';
  }

  @override
  String targetRangeMin(String min) {
    return 'Minimum $min kcal';
  }

  @override
  String get mealMenuEdit => 'Edit meal';

  @override
  String get mealMenuSplit => 'Split across days';

  @override
  String get mealMenuSaveRecipe => 'Save as recipe';

  @override
  String get mealMenuDelete => 'Delete meal';

  @override
  String get mealFinish => 'Finish meal';

  @override
  String get mealAddTo => 'Add to this meal';

  @override
  String mealSavedToRecipes(String name) {
    return 'Saved \"$name\" to recipes';
  }

  @override
  String get editMealTitle => 'Edit meal';

  @override
  String get editMealName => 'Name';

  @override
  String get editMealType => 'Meal type';

  @override
  String get editMealWhen => 'When';

  @override
  String get recipesTitle => 'Recipes';

  @override
  String get recipesEmpty =>
      'No recipes yet.\nCreate one to reuse meals, share them, or batch-cook and split across days.';

  @override
  String get recipeNew => 'New recipe';

  @override
  String recipeServings(String count) {
    return '$count servings';
  }

  @override
  String recipeImported(String name) {
    return 'Imported \"$name\"';
  }

  @override
  String get qrNotRecipe => 'That QR code is not a recipe.';

  @override
  String get createBuildManually => 'Build manually';

  @override
  String get createBuildManuallySub => 'Add ingredients one by one';

  @override
  String get createFromList => 'From an ingredient list';

  @override
  String get createFromListSub =>
      'Photograph a printed list — save it or log it as a meal';

  @override
  String get createFromQr => 'Import from QR code';

  @override
  String get createFromQrSub => 'Scan a shared recipe';

  @override
  String genericError(String error) {
    return 'Error: $error';
  }

  @override
  String get settingsTargets => 'Calorie targets';

  @override
  String get settingsTargetsHelp =>
      'Set a minimum, a maximum, or both. A minimum helps if you need to make sure you eat enough. Leave blank to use the default.';

  @override
  String get settingsTargetDefault => 'Default';

  @override
  String get settingsCustomizePerDay => 'Customize per day';

  @override
  String get settingsCustomizePerDaySub =>
      'Training days and weekends can differ';

  @override
  String get settingsLogging => 'Logging';

  @override
  String get settingsMealTimes => 'Meal times';

  @override
  String get settingsMealTimesSub => 'Names each meal by the time you log it';

  @override
  String get settingsMealTimesHelp =>
      'A new meal is named after the window its first item falls in (e.g. \"Breakfast 08:23\"). Anything outside these windows is a snack. You can always rename a meal.';

  @override
  String get settingsFoodData => 'Food data';

  @override
  String get settingsOfflineRegions => 'Offline regions';

  @override
  String get settingsOfflineRegionsSub =>
      'Download country product databases for offline search';

  @override
  String get settingsHealthConnect => 'Health Connect';

  @override
  String get settingsHealthSync => 'Sync to Health Connect';

  @override
  String get settingsHealthSyncSub =>
      'Write logged calories & macros to Health Connect';

  @override
  String get settingsHealthTimeNote =>
      'Entries sync at the time you logged them';

  @override
  String get settingsHealthTimeNoteSub =>
      'Back-date a meal from its ⋮ menu to change its time.';

  @override
  String get settingsDataBackup => 'Data & backup';

  @override
  String get settingsExport => 'Export backup';

  @override
  String get settingsExportSub => 'Share a .zip (JSON + CSV)';

  @override
  String get settingsImport => 'Import backup';

  @override
  String get settingsImportSub => 'Restore from a .zip (replaces all data)';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutBody =>
      'Ad-free, no subscriptions. Data from Open Food Facts and USDA FoodData Central.';

  @override
  String get offThanksTitle => 'Thanks to Open Food Facts';

  @override
  String get offThanksBody =>
      'Knabberfuchs is built on Open Food Facts — a free, open, crowdsourced food database kept alive by volunteers around the world. Without their work, this app simply would not exist.\n\nIf Knabberfuchs is useful to you, please consider supporting them.';

  @override
  String get offDonate => 'Donate to Open Food Facts';

  @override
  String get healthSyncOff => 'Health Connect sync turned off.';

  @override
  String get healthUnavailable =>
      'Health Connect is not available on this device.';

  @override
  String get healthNoPermission => 'Health Connect permission was not granted.';

  @override
  String get healthSyncOn => 'Health Connect sync on — today pushed.';

  @override
  String backupExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get backupReplaceTitle => 'Replace all data?';

  @override
  String get backupReplaceBody =>
      'Importing will replace your current entries, custom foods, recipes, targets, and settings with the backup contents.';

  @override
  String get backupRestored => 'Backup restored.';

  @override
  String backupImportFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get amountLabel => 'Amount';

  @override
  String get editEntryTitle => 'Edit entry';

  @override
  String kcalPer100(String kcal) {
    return '$kcal kcal / 100 g';
  }

  @override
  String volumeApprox(String grams) {
    return '≈ $grams g (assumes ~1 g/ml)';
  }

  @override
  String oneServing(String grams) {
    return '1 serving ($grams g)';
  }

  @override
  String get searchFoodsHint => 'Search foods…';

  @override
  String get searchRecentlyUsed => 'Recently used';

  @override
  String get createCustomFood => 'Create custom food';

  @override
  String get searchEmptyPrompt =>
      'Search for a food, scan a barcode,\nor create your own.';

  @override
  String searchNoMatches(String query) {
    return 'No matches for \"$query\".';
  }

  @override
  String kcalPer100Short(String kcal) {
    return '$kcal kcal\n/100 g';
  }

  @override
  String get sourceOff => 'Open Food Facts';

  @override
  String get sourceUsda => 'USDA';

  @override
  String get sourceCustom => 'Custom';

  @override
  String get sourceContributed => 'Added by you';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get selectFood => 'Select food';
}
