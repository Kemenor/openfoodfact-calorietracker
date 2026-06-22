import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
  ];

  /// Application name (brand; usually not translated)
  ///
  /// In en, this message translates to:
  /// **'Knabberfuchs'**
  String get appTitle;

  /// Bottom navigation: the daily diary tab
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get navDay;

  /// Bottom navigation: the recipes tab
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get navRecipes;

  /// Bottom navigation: the settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get actionImport;

  /// Settings section header for the app language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// Settings row title for choosing the UI language
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// Language option that follows the device locale
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @dayPreviousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get dayPreviousDay;

  /// No description provided for @dayNextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get dayNextDay;

  /// No description provided for @dayAddFood.
  ///
  /// In en, this message translates to:
  /// **'Add food'**
  String get dayAddFood;

  /// No description provided for @dayMealFromList.
  ///
  /// In en, this message translates to:
  /// **'Meal from an ingredient list'**
  String get dayMealFromList;

  /// Empty-state hint on the Day screen
  ///
  /// In en, this message translates to:
  /// **'Tap + to start a meal.\nEverything you add flows into it until you tap ✓ (or 15 min pass).'**
  String get dayEmptyHint;

  /// No description provided for @unitKcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get unitKcal;

  /// No description provided for @macroProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get macroProtein;

  /// No description provided for @macroCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get macroCarbs;

  /// No description provided for @macroFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get macroFat;

  /// No description provided for @targetOver.
  ///
  /// In en, this message translates to:
  /// **'{kcal} over'**
  String targetOver(String kcal);

  /// No description provided for @targetToGo.
  ///
  /// In en, this message translates to:
  /// **'{kcal} to go'**
  String targetToGo(String kcal);

  /// No description provided for @targetLeft.
  ///
  /// In en, this message translates to:
  /// **'{kcal} left'**
  String targetLeft(String kcal);

  /// No description provided for @targetMinReached.
  ///
  /// In en, this message translates to:
  /// **'minimum reached'**
  String get targetMinReached;

  /// No description provided for @targetRangeBoth.
  ///
  /// In en, this message translates to:
  /// **'Target {min}–{max} kcal'**
  String targetRangeBoth(String min, String max);

  /// No description provided for @targetRangeMax.
  ///
  /// In en, this message translates to:
  /// **'Target {max} kcal'**
  String targetRangeMax(String max);

  /// No description provided for @targetRangeMin.
  ///
  /// In en, this message translates to:
  /// **'Minimum {min} kcal'**
  String targetRangeMin(String min);

  /// No description provided for @mealMenuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit meal'**
  String get mealMenuEdit;

  /// No description provided for @mealMenuSplit.
  ///
  /// In en, this message translates to:
  /// **'Split across days'**
  String get mealMenuSplit;

  /// No description provided for @mealMenuSaveRecipe.
  ///
  /// In en, this message translates to:
  /// **'Save as recipe'**
  String get mealMenuSaveRecipe;

  /// No description provided for @mealMenuDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete meal'**
  String get mealMenuDelete;

  /// No description provided for @mealFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish meal'**
  String get mealFinish;

  /// No description provided for @mealAddTo.
  ///
  /// In en, this message translates to:
  /// **'Add to this meal'**
  String get mealAddTo;

  /// No description provided for @mealSavedToRecipes.
  ///
  /// In en, this message translates to:
  /// **'Saved \"{name}\" to recipes'**
  String mealSavedToRecipes(String name);

  /// No description provided for @editMealTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit meal'**
  String get editMealTitle;

  /// No description provided for @editMealName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editMealName;

  /// No description provided for @editMealType.
  ///
  /// In en, this message translates to:
  /// **'Meal type'**
  String get editMealType;

  /// No description provided for @editMealWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get editMealWhen;

  /// No description provided for @recipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipesTitle;

  /// No description provided for @recipesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet.\nCreate one to reuse meals, share them, or batch-cook and split across days.'**
  String get recipesEmpty;

  /// No description provided for @recipeNew.
  ///
  /// In en, this message translates to:
  /// **'New recipe'**
  String get recipeNew;

  /// No description provided for @recipeServings.
  ///
  /// In en, this message translates to:
  /// **'{count} servings'**
  String recipeServings(String count);

  /// No description provided for @recipeImported.
  ///
  /// In en, this message translates to:
  /// **'Imported \"{name}\"'**
  String recipeImported(String name);

  /// No description provided for @qrNotRecipe.
  ///
  /// In en, this message translates to:
  /// **'That QR code is not a recipe.'**
  String get qrNotRecipe;

  /// No description provided for @createBuildManually.
  ///
  /// In en, this message translates to:
  /// **'Build manually'**
  String get createBuildManually;

  /// No description provided for @createBuildManuallySub.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients one by one'**
  String get createBuildManuallySub;

  /// No description provided for @createFromList.
  ///
  /// In en, this message translates to:
  /// **'From an ingredient list'**
  String get createFromList;

  /// No description provided for @createFromListSub.
  ///
  /// In en, this message translates to:
  /// **'Photograph a printed list — save it or log it as a meal'**
  String get createFromListSub;

  /// No description provided for @createFromQr.
  ///
  /// In en, this message translates to:
  /// **'Import from QR code'**
  String get createFromQr;

  /// No description provided for @createFromQrSub.
  ///
  /// In en, this message translates to:
  /// **'Scan a shared recipe'**
  String get createFromQrSub;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String genericError(String error);

  /// No description provided for @settingsTargets.
  ///
  /// In en, this message translates to:
  /// **'Calorie targets'**
  String get settingsTargets;

  /// No description provided for @settingsTargetsHelp.
  ///
  /// In en, this message translates to:
  /// **'Set a minimum, a maximum, or both. A minimum helps if you need to make sure you eat enough. Leave blank to use the default.'**
  String get settingsTargetsHelp;

  /// No description provided for @settingsTargetDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get settingsTargetDefault;

  /// No description provided for @settingsCustomizePerDay.
  ///
  /// In en, this message translates to:
  /// **'Customize per day'**
  String get settingsCustomizePerDay;

  /// No description provided for @settingsCustomizePerDaySub.
  ///
  /// In en, this message translates to:
  /// **'Training days and weekends can differ'**
  String get settingsCustomizePerDaySub;

  /// No description provided for @settingsLogging.
  ///
  /// In en, this message translates to:
  /// **'Logging'**
  String get settingsLogging;

  /// No description provided for @settingsMealTimes.
  ///
  /// In en, this message translates to:
  /// **'Meal times'**
  String get settingsMealTimes;

  /// No description provided for @settingsMealTimesSub.
  ///
  /// In en, this message translates to:
  /// **'Names each meal by the time you log it'**
  String get settingsMealTimesSub;

  /// No description provided for @settingsMealTimesHelp.
  ///
  /// In en, this message translates to:
  /// **'A new meal is named after the window its first item falls in (e.g. \"Breakfast 08:23\"). Anything outside these windows is a snack. You can always rename a meal.'**
  String get settingsMealTimesHelp;

  /// No description provided for @settingsFoodData.
  ///
  /// In en, this message translates to:
  /// **'Food data'**
  String get settingsFoodData;

  /// No description provided for @settingsOfflineRegions.
  ///
  /// In en, this message translates to:
  /// **'Offline regions'**
  String get settingsOfflineRegions;

  /// No description provided for @settingsOfflineRegionsSub.
  ///
  /// In en, this message translates to:
  /// **'Download country product databases for offline search'**
  String get settingsOfflineRegionsSub;

  /// No description provided for @settingsHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Health Connect'**
  String get settingsHealthConnect;

  /// No description provided for @settingsHealthSync.
  ///
  /// In en, this message translates to:
  /// **'Sync to Health Connect'**
  String get settingsHealthSync;

  /// No description provided for @settingsHealthSyncSub.
  ///
  /// In en, this message translates to:
  /// **'Write logged calories & macros to Health Connect'**
  String get settingsHealthSyncSub;

  /// No description provided for @settingsHealthTimeNote.
  ///
  /// In en, this message translates to:
  /// **'Entries sync at the time you logged them'**
  String get settingsHealthTimeNote;

  /// No description provided for @settingsHealthTimeNoteSub.
  ///
  /// In en, this message translates to:
  /// **'Back-date a meal from its ⋮ menu to change its time.'**
  String get settingsHealthTimeNoteSub;

  /// No description provided for @settingsDataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data & backup'**
  String get settingsDataBackup;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get settingsExport;

  /// No description provided for @settingsExportSub.
  ///
  /// In en, this message translates to:
  /// **'Share a .zip (JSON + CSV)'**
  String get settingsExportSub;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get settingsImport;

  /// No description provided for @settingsImportSub.
  ///
  /// In en, this message translates to:
  /// **'Restore from a .zip (replaces all data)'**
  String get settingsImportSub;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Ad-free, no subscriptions. Data from Open Food Facts and USDA FoodData Central.'**
  String get settingsAboutBody;

  /// No description provided for @offThanksTitle.
  ///
  /// In en, this message translates to:
  /// **'Thanks to Open Food Facts'**
  String get offThanksTitle;

  /// No description provided for @offThanksBody.
  ///
  /// In en, this message translates to:
  /// **'Knabberfuchs is built on Open Food Facts — a free, open, crowdsourced food database kept alive by volunteers around the world. Without their work, this app simply would not exist.\n\nIf Knabberfuchs is useful to you, please consider supporting them.'**
  String get offThanksBody;

  /// No description provided for @offDonate.
  ///
  /// In en, this message translates to:
  /// **'Donate to Open Food Facts'**
  String get offDonate;

  /// No description provided for @healthSyncOff.
  ///
  /// In en, this message translates to:
  /// **'Health Connect sync turned off.'**
  String get healthSyncOff;

  /// No description provided for @healthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Health Connect is not available on this device.'**
  String get healthUnavailable;

  /// No description provided for @healthNoPermission.
  ///
  /// In en, this message translates to:
  /// **'Health Connect permission was not granted.'**
  String get healthNoPermission;

  /// No description provided for @healthSyncOn.
  ///
  /// In en, this message translates to:
  /// **'Health Connect sync on — today pushed.'**
  String get healthSyncOn;

  /// No description provided for @backupExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String backupExportFailed(String error);

  /// No description provided for @backupReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace all data?'**
  String get backupReplaceTitle;

  /// No description provided for @backupReplaceBody.
  ///
  /// In en, this message translates to:
  /// **'Importing will replace your current entries, custom foods, recipes, targets, and settings with the backup contents.'**
  String get backupReplaceBody;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored.'**
  String get backupRestored;

  /// No description provided for @backupImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String backupImportFailed(String error);

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @editEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editEntryTitle;

  /// No description provided for @kcalPer100.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal / 100 g'**
  String kcalPer100(String kcal);

  /// No description provided for @volumeApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {grams} g (assumes ~1 g/ml)'**
  String volumeApprox(String grams);

  /// No description provided for @oneServing.
  ///
  /// In en, this message translates to:
  /// **'1 serving ({grams} g)'**
  String oneServing(String grams);

  /// No description provided for @searchFoodsHint.
  ///
  /// In en, this message translates to:
  /// **'Search foods…'**
  String get searchFoodsHint;

  /// No description provided for @searchRecentlyUsed.
  ///
  /// In en, this message translates to:
  /// **'Recently used'**
  String get searchRecentlyUsed;

  /// No description provided for @createCustomFood.
  ///
  /// In en, this message translates to:
  /// **'Create custom food'**
  String get createCustomFood;

  /// No description provided for @searchEmptyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search for a food, scan a barcode,\nor create your own.'**
  String get searchEmptyPrompt;

  /// No description provided for @searchNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches for \"{query}\".'**
  String searchNoMatches(String query);

  /// No description provided for @kcalPer100Short.
  ///
  /// In en, this message translates to:
  /// **'{kcal} kcal\n/100 g'**
  String kcalPer100Short(String kcal);

  /// No description provided for @sourceOff.
  ///
  /// In en, this message translates to:
  /// **'Open Food Facts'**
  String get sourceOff;

  /// No description provided for @sourceUsda.
  ///
  /// In en, this message translates to:
  /// **'USDA'**
  String get sourceUsda;

  /// No description provided for @sourceCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get sourceCustom;

  /// No description provided for @sourceContributed.
  ///
  /// In en, this message translates to:
  /// **'Added by you'**
  String get sourceContributed;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @selectFood.
  ///
  /// In en, this message translates to:
  /// **'Select food'**
  String get selectFood;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
