import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @finishedProjects.
  ///
  /// In en, this message translates to:
  /// **'Finished Projects'**
  String get finishedProjects;

  /// No description provided for @productiveDay.
  ///
  /// In en, this message translates to:
  /// **'Productive Days'**
  String get productiveDay;

  /// No description provided for @finishedTasks.
  ///
  /// In en, this message translates to:
  /// **'Finished Tasks'**
  String get finishedTasks;

  /// No description provided for @recentProjects.
  ///
  /// In en, this message translates to:
  /// **'Recent Projects'**
  String get recentProjects;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @nextTask.
  ///
  /// In en, this message translates to:
  /// **'Next Task'**
  String get nextTask;

  /// No description provided for @ad.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get ad;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get goodEvening;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night,'**
  String get goodNight;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Create!'**
  String get homeTagline;

  /// No description provided for @failedToLoadProjects.
  ///
  /// In en, this message translates to:
  /// **'Failed to load projects: {error}'**
  String failedToLoadProjects(String error);

  /// No description provided for @fromProject.
  ///
  /// In en, this message translates to:
  /// **'from: {projectName}'**
  String fromProject(String projectName);

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get log;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @createProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Project'**
  String get createProjectTitle;

  /// No description provided for @createProjectHeadline.
  ///
  /// In en, this message translates to:
  /// **'Start Something Great'**
  String get createProjectHeadline;

  /// No description provided for @addCoverImage.
  ///
  /// In en, this message translates to:
  /// **'Add Cover Image'**
  String get addCoverImage;

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// No description provided for @projectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Project Name*'**
  String get projectNameLabel;

  /// No description provided for @projectNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Teak Bookshelf'**
  String get projectNameHint;

  /// No description provided for @projectNameValidationError.
  ///
  /// In en, this message translates to:
  /// **'Project name cannot be empty'**
  String get projectNameValidationError;

  /// No description provided for @projectDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get projectDescriptionLabel;

  /// No description provided for @projectDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Briefly describe your project...'**
  String get projectDescriptionHint;

  /// No description provided for @projectStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Project Status'**
  String get projectStatusLabel;

  /// No description provided for @completionDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Completion Date (Optional)'**
  String get completionDateLabel;

  /// No description provided for @completionDateHint.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get completionDateHint;

  /// No description provided for @saveProjectButton.
  ///
  /// In en, this message translates to:
  /// **'Save Project'**
  String get saveProjectButton;

  /// No description provided for @projectSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project saved successfully!'**
  String get projectSavedSuccess;

  /// No description provided for @allProject.
  ///
  /// In en, this message translates to:
  /// **'All Project'**
  String get allProject;

  /// No description provided for @deleteProject.
  ///
  /// In en, this message translates to:
  /// **'Delete Project'**
  String get deleteProject;

  /// No description provided for @projectDeleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete this project?'**
  String get projectDeleteConfirmation;

  /// No description provided for @projectDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Project deleted successfully!'**
  String get projectDeletedSuccess;

  /// No description provided for @dataDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Projects deleted successfully!'**
  String get dataDeletedSuccess;

  /// No description provided for @dataUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully!'**
  String get dataUpdatedSuccess;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @projectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Project Not Found!'**
  String get projectNotFound;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project Description'**
  String get projectDescription;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get createdDate;

  /// No description provided for @editProject.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get editProject;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get taskTitleLabel;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// No description provided for @taskAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Task added successfully!'**
  String get taskAddedSuccess;

  /// No description provided for @emptyTask.
  ///
  /// In en, this message translates to:
  /// **'There is no task for this project'**
  String get emptyTask;

  /// No description provided for @choosePicture.
  ///
  /// In en, this message translates to:
  /// **'Choose Picture'**
  String get choosePicture;

  /// No description provided for @changePicture.
  ///
  /// In en, this message translates to:
  /// **'Change Picture'**
  String get changePicture;

  /// No description provided for @logNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (Optional)'**
  String get logNoteLabel;

  /// No description provided for @addLog.
  ///
  /// In en, this message translates to:
  /// **'Add Log'**
  String get addLog;

  /// No description provided for @emptyLog.
  ///
  /// In en, this message translates to:
  /// **'There is no log for this project'**
  String get emptyLog;

  /// No description provided for @logAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Log added successfully!'**
  String get logAddedSuccess;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong!'**
  String get somethingWentWrong;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Delete'**
  String get confirmDelete;

  /// No description provided for @confirmationDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete this?'**
  String get confirmationDelete;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Status'**
  String get changeStatus;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
