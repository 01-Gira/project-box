// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get finishedProjects => 'Proyectos terminados';

  @override
  String get productiveDay => 'Días productivo';

  @override
  String get finishedTasks => 'Tareas terminadas';

  @override
  String get recentProjects => 'Proyectos recientes';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get nextTask => 'Siguiente tarea';

  @override
  String get ad => 'Anuncio';

  @override
  String get goodMorning => 'Buen día,';

  @override
  String get goodAfternoon => 'Buenas tardes,';

  @override
  String get goodEvening => 'Buenas noches,';

  @override
  String get goodNight => 'Buenas noches,';

  @override
  String get homeTagline => '¡Creemos!';

  @override
  String failedToLoadProjects(String error) {
    return 'No se pudo cargar proyectos: $error';
  }

  @override
  String fromProject(String projectName) {
    return 'De: $projectName';
  }

  @override
  String get task => 'Tarea';

  @override
  String get log => 'Registro';

  @override
  String get info => 'Información';

  @override
  String get createProjectTitle => 'Crear un nuevo proyecto';

  @override
  String get createProjectHeadline => 'Empiece algo genial';

  @override
  String get addCoverImage => 'Agregar imagen de portada';

  @override
  String failedToPickImage(String error) {
    return 'No se pudo elegir la imagen: $error';
  }

  @override
  String get projectNameLabel => 'Nombre del proyecto*';

  @override
  String get projectNameHint => 'Ejemplo: estantería de teca';

  @override
  String get projectNameValidationError =>
      'El nombre del proyecto no puede estar vacío';

  @override
  String get projectDescriptionLabel => 'Descripción (opcional)';

  @override
  String get projectDescriptionHint => 'Describe brevemente tu proyecto ...';

  @override
  String get projectStatusLabel => 'Estado del proyecto';

  @override
  String get completionDateLabel => 'Fecha de finalización (opcional)';

  @override
  String get completionDateHint => 'Elegir fecha';

  @override
  String get saveProjectButton => 'Guardar el proyecto';

  @override
  String get projectSavedSuccess => '¡Proyecto guardado con éxito!';

  @override
  String get allProject => 'Todos los proyectos';

  @override
  String get deleteProject => 'Proyecto Eliminar';

  @override
  String get projectDeleteConfirmation =>
      '¿Estás seguro de que quieres eliminar este proyecto?';

  @override
  String get projectDeletedSuccess => '¡Proyecto eliminado con éxito!';

  @override
  String get dataDeletedSuccess => '¡Proyectos eliminados con éxito!';

  @override
  String get dataUpdatedSuccess => '¡Datos actualizados con éxito!';

  @override
  String get search => 'Buscar';

  @override
  String get projectNotFound => 'Proyecto no encontrado!';

  @override
  String get projectDescription => 'Descripción del proyecto';

  @override
  String get createdDate => 'Fecha creada';

  @override
  String get editProject => 'Editar proyecto';

  @override
  String get taskTitleLabel => 'Título';

  @override
  String get addTask => 'Agregar tarea';

  @override
  String get taskAddedSuccess => '¡Tarea agregada con éxito!';

  @override
  String get emptyTask => 'No hay tarea para este proyecto';

  @override
  String get choosePicture => 'Elija una imagen';

  @override
  String get changePicture => 'Cambiar de imagen';

  @override
  String get logNoteLabel => 'Nota (opcional)';

  @override
  String get addLog => 'Agregar registro';

  @override
  String get emptyLog => 'No hay registro para este proyecto';

  @override
  String get logAddedSuccess => '¡Registro agregado con éxito!';

  @override
  String get tryAgain => 'Intentar otra vez';

  @override
  String get somethingWentWrong => '¡Algo salió mal!';

  @override
  String get save => 'Ahorrar';

  @override
  String get edit => 'Editar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Borrar';

  @override
  String get confirmDelete => 'Confirmación eliminar';

  @override
  String get confirmationDelete =>
      '¿Estás seguro de que quieres eliminar esto?';

  @override
  String get changeStatus => 'Estado de cambio';

  @override
  String get appTitle => 'Project Box';

  @override
  String get projectBoxExport => 'Exportación de Project Box';

  @override
  String get export => 'Exportar';

  @override
  String get import => 'Importar';

  @override
  String get settings => 'Ajustes';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Luz';

  @override
  String get dark => 'Oscuro';

  @override
  String get noData => 'Sin datos';

  @override
  String get manual => 'Manual';

  @override
  String get dueDate => 'Fecha de vencimiento';

  @override
  String get priority => 'Prioridad';

  @override
  String priorityLabel(String priority) {
    return 'P: $priority';
  }
}
