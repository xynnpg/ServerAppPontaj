// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pontaj Admin';

  @override
  String get dashboard => 'Tablero';

  @override
  String get users => 'Usuarios';

  @override
  String get settings => 'Configuración';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signInMessage => 'Inicie sesión para acceder al portal.';

  @override
  String get requiredField => 'Requerido';

  @override
  String get schoolName => 'Colegiul Național\n\"Vasile Goldiș\"';

  @override
  String get excellenceInEducation => 'Excelencia en Educación';

  @override
  String get noDataToExport => 'No hay datos para exportar';

  @override
  String get statsExportedSuccess => 'Estadísticas exportadas a CSV con éxito';

  @override
  String get editProfessor => 'Editar Profesor';

  @override
  String get addProfessor => 'Añadir Profesor';

  @override
  String get name => 'Nombre';

  @override
  String get emailRequired => 'El correo electrónico es obligatorio';

  @override
  String get emailInvalid => 'El correo debe tener el formato: user@domain.com';

  @override
  String get newPassword => 'Nueva Contraseña';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get add => 'Añadir';

  @override
  String get confirmDelete => 'Confirmar Eliminación';

  @override
  String deleteConfirmation(String name) {
    return '¿Estás seguro de que quieres eliminar a $name?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get downloadApk => 'Descargar APK';

  @override
  String get debugConsole => 'Consola de Depuración';

  @override
  String get downloadCsv => 'Descargar CSV';

  @override
  String get professors => 'Profesores';

  @override
  String get total => 'Total';

  @override
  String get idGrowth => 'Crecimiento de ID (Actividad)';

  @override
  String get systemStatus => 'Estado del Sistema';

  @override
  String get logs => 'Registros';

  @override
  String get clearLogs => 'Borrar Registros';

  @override
  String get clearLogsConfirmation =>
      '¿Estás seguro de que quieres borrar todos los registros?';

  @override
  String get clear => 'Borrar';

  @override
  String get searchLogs => 'Buscar registros...';

  @override
  String get all => 'Todos';

  @override
  String get withInput => 'Con Entrada';

  @override
  String get withOutput => 'Con Salida';

  @override
  String get stackTraces => 'Rastros de Pila';

  @override
  String get noLogsMatch => 'Ningún registro coincide con tus filtros';

  @override
  String get noLogsYet => 'Aún no hay registros';

  @override
  String get input => 'Entrada';

  @override
  String get output => 'Salida';

  @override
  String get trace => 'RASTRO';

  @override
  String get fullMessage => 'Mensaje Completo';

  @override
  String get stackTrace => 'Rastro de Pila';

  @override
  String copied(String title) {
    return '$title copiado';
  }
}
