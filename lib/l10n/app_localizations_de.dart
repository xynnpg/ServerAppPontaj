// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pontaj Admin';

  @override
  String get dashboard => 'Armaturenbrett';

  @override
  String get users => 'Benutzer';

  @override
  String get settings => 'Einstellungen';

  @override
  String get logout => 'Abmelden';

  @override
  String get login => 'Anmelden';

  @override
  String get email => 'Email';

  @override
  String get password => 'Passwort';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String get signInMessage =>
      'Bitte melden Sie sich an, um auf das Portal zuzugreifen.';

  @override
  String get requiredField => 'Erforderlich';

  @override
  String get schoolName => 'Colegiul Național\n\"Vasile Goldiș\"';

  @override
  String get excellenceInEducation => 'Exzellenz in der Bildung';

  @override
  String get noDataToExport => 'Keine Daten zum Exportieren';

  @override
  String get statsExportedSuccess =>
      'Statistiken erfolgreich als CSV exportiert';

  @override
  String get editProfessor => 'Professor bearbeiten';

  @override
  String get addProfessor => 'Professor hinzufügen';

  @override
  String get name => 'Name';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get emailInvalid => 'E-Mail muss im Format sein: user@domain.com';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get passwordMinLength =>
      'Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get add => 'Hinzufügen';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String deleteConfirmation(String name) {
    return 'Sind Sie sicher, dass Sie $name löschen möchten?';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get downloadApk => 'APK herunterladen';

  @override
  String get debugConsole => 'Debug-Konsole';

  @override
  String get downloadCsv => 'CSV herunterladen';

  @override
  String get professors => 'Professoren';

  @override
  String get total => 'Gesamt';

  @override
  String get idGrowth => 'ID-Wachstum (Aktivität)';

  @override
  String get systemStatus => 'Systemstatus';

  @override
  String get logs => 'Protokolle';

  @override
  String get clearLogs => 'Protokolle löschen';

  @override
  String get clearLogsConfirmation =>
      'Sind Sie sicher, dass Sie alle Protokolle löschen möchten?';

  @override
  String get clear => 'Löschen';

  @override
  String get searchLogs => 'Protokolle durchsuchen...';

  @override
  String get all => 'Alle';

  @override
  String get withInput => 'Mit Eingabe';

  @override
  String get withOutput => 'Mit Ausgabe';

  @override
  String get stackTraces => 'Stack-Traces';

  @override
  String get noLogsMatch => 'Keine Protokolle entsprechen Ihren Filtern';

  @override
  String get noLogsYet => 'Noch keine Protokolle';

  @override
  String get input => 'Eingabe';

  @override
  String get output => 'Ausgabe';

  @override
  String get trace => 'SPUR';

  @override
  String get fullMessage => 'Vollständige Nachricht';

  @override
  String get stackTrace => 'Stack-Trace';

  @override
  String copied(String title) {
    return '$title kopiert';
  }
}
