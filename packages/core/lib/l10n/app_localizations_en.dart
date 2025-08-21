// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get finishedProjects => 'Finished Projects';

  @override
  String get productiveDay => 'Productive Days';

  @override
  String get finishedTasks => 'Finished Tasks';

  @override
  String get recentProjects => 'Recent Projects';

  @override
  String get seeAll => 'See All';

  @override
  String get nextTask => 'Next Task';

  @override
  String get ad => 'Ad';

  @override
  String get goodMorning => 'Good Morning,';

  @override
  String get goodAfternoon => 'Good Afternoon,';

  @override
  String get goodEvening => 'Good Evening,';

  @override
  String get goodNight => 'Good Night,';

  @override
  String get homeTagline => 'Let\'s Create!';

  @override
  String failedToLoadProjects(String error) {
    return 'Failed to load projects: $error';
  }

  @override
  String fromProject(String projectName) {
    return 'from: $projectName';
  }

  @override
  String get task => 'Task';

  @override
  String get log => 'Log';

  @override
  String get info => 'Info';

  @override
  String get createProjectTitle => 'Create New Project';

  @override
  String get createProjectHeadline => 'Start Something Great';

  @override
  String get addCoverImage => 'Add Cover Image';

  @override
  String failedToPickImage(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String get projectNameLabel => 'Project Name*';

  @override
  String get projectNameHint => 'Example: Teak Bookshelf';

  @override
  String get projectNameValidationError => 'Project name cannot be empty';

  @override
  String get projectDescriptionLabel => 'Description (Optional)';

  @override
  String get projectDescriptionHint => 'Briefly describe your project...';

  @override
  String get projectStatusLabel => 'Project Status';

  @override
  String get completionDateLabel => 'Completion Date (Optional)';

  @override
  String get completionDateHint => 'Choose Date';

  @override
  String get saveProjectButton => 'Save Project';

  @override
  String get projectSavedSuccess => 'Project saved successfully!';

  @override
  String get allProject => 'All Project';

  @override
  String get deleteProject => 'Delete Project';

  @override
  String get projectDeleteConfirmation =>
      'Are you sure want to delete this project?';

  @override
  String get projectDeletedSuccess => 'Project deleted successfully!';

  @override
  String get dataDeletedSuccess => 'Projects deleted successfully!';

  @override
  String get dataUpdatedSuccess => 'Data updated successfully!';

  @override
  String get search => 'Search';

  @override
  String get projectNotFound => 'Project Not Found!';

  @override
  String get projectDescription => 'Project Description';

  @override
  String get createdDate => 'Created Date';

  @override
  String get editProject => 'Edit Project';

  @override
  String get taskTitleLabel => 'Title';

  @override
  String get addTask => 'Add Task';

  @override
  String get taskAddedSuccess => 'Task added successfully!';

  @override
  String get emptyTask => 'There is no task for this project';

  @override
  String get choosePicture => 'Choose Picture';

  @override
  String get changePicture => 'Change Picture';

  @override
  String get logNoteLabel => 'Note (Optional)';

  @override
  String get addLog => 'Add Log';

  @override
  String get emptyLog => 'There is no log for this project';

  @override
  String get logAddedSuccess => 'Log added successfully!';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get somethingWentWrong => 'Something Went Wrong!';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Confirmation Delete';

  @override
  String get confirmationDelete => 'Are you sure want to delete this?';

  @override
  String get changeStatus => 'Change Status';
}
