// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get finishedProjects => 'Projets finis';

  @override
  String get productiveDay => 'Jours productifs';

  @override
  String get finishedTasks => 'Tâches finies';

  @override
  String get recentProjects => 'Projets récents';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get nextTask => 'Tâche suivante';

  @override
  String get ad => 'Annonce';

  @override
  String get goodMorning => 'Bonjour,';

  @override
  String get goodAfternoon => 'Bon après-midi,';

  @override
  String get goodEvening => 'Bonne soirée,';

  @override
  String get goodNight => 'Bonne nuit,';

  @override
  String get homeTagline => 'Créons!';

  @override
  String failedToLoadProjects(String error) {
    return 'Échec du chargement des projets: $error';
  }

  @override
  String fromProject(String projectName) {
    return 'De: $projectName';
  }

  @override
  String get task => 'Tâche';

  @override
  String get log => 'Enregistrer';

  @override
  String get info => 'Informations';

  @override
  String get createProjectTitle => 'Créer un nouveau projet';

  @override
  String get createProjectHeadline => 'Commencer quelque chose de génial';

  @override
  String get addCoverImage => 'Ajouter une image de couverture';

  @override
  String failedToPickImage(String error) {
    return 'Échec de l\'image: $error';
  }

  @override
  String get projectNameLabel => 'Nom du projet *';

  @override
  String get projectNameHint => 'Exemple: bibliothèque en teck';

  @override
  String get projectNameValidationError =>
      'Le nom du projet ne peut pas être vide';

  @override
  String get projectDescriptionLabel => 'Description (facultative)';

  @override
  String get projectDescriptionHint => 'Décrivez brièvement votre projet ...';

  @override
  String get projectStatusLabel => 'État du projet';

  @override
  String get completionDateLabel => 'Date d\'achèvement (facultatif)';

  @override
  String get completionDateHint => 'Choisir la date';

  @override
  String get saveProjectButton => 'SAVER PROJET';

  @override
  String get projectSavedSuccess => 'Project Sauvé avec succès!';

  @override
  String get allProject => 'Tout projet';

  @override
  String get deleteProject => 'Supprimer le projet';

  @override
  String get projectDeleteConfirmation =>
      'Êtes-vous sûr de supprimer ce projet?';

  @override
  String get projectDeletedSuccess => 'Projet supprimé avec succès!';

  @override
  String get dataDeletedSuccess => 'Projets supprimés avec succès!';

  @override
  String get dataUpdatedSuccess => 'Données mises à jour avec succès!';

  @override
  String get search => 'Recherche';

  @override
  String get projectNotFound => 'Projet introuvable!';

  @override
  String get projectDescription => 'Description du projet';

  @override
  String get createdDate => 'Date de création';

  @override
  String get editProject => 'Modifier le projet';

  @override
  String get taskTitleLabel => 'Titre';

  @override
  String get addTask => 'Ajouter une tâche';

  @override
  String get taskAddedSuccess => 'Tâche ajoutée avec succès!';

  @override
  String get emptyTask => 'Il n\'y a pas de tâche pour ce projet';

  @override
  String get choosePicture => 'Choisir l\'image';

  @override
  String get changePicture => 'Changer d\'image';

  @override
  String get logNoteLabel => 'Remarque (facultatif)';

  @override
  String get addLog => 'Ajouter le journal';

  @override
  String get emptyLog => 'Il n\'y a pas de journal pour ce projet';

  @override
  String get logAddedSuccess => 'Le journal a ajouté avec succès!';

  @override
  String get tryAgain => 'Essayer à nouveau';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé!';

  @override
  String get save => 'Sauvegarder';

  @override
  String get edit => 'Modifier';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get confirmDelete => 'Suppression de confirmation';

  @override
  String get confirmationDelete => 'Êtes-vous sûr de vouloir supprimer cela?';

  @override
  String get changeStatus => 'Changer le statut';

  @override
  String get appTitle => 'Project Box';

  @override
  String get projectBoxExport => 'Exportation Project Box';

  @override
  String get export => 'Exporter';

  @override
  String get import => 'Importer';

  @override
  String get settings => 'Paramètres';

  @override
  String get system => 'Système';

  @override
  String get light => 'Lumière';

  @override
  String get dark => 'Sombre';

  @override
  String get noData => 'Pas de données';

  @override
  String get manual => 'Manuel';

  @override
  String get dueDate => 'Date d\'échéance';

  @override
  String get priority => 'Priorité';

  @override
  String priorityLabel(String priority) {
    return 'P: $priority';
  }
}
