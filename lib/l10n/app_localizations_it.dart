// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Pontaj Admin';

  @override
  String get dashboard => 'Cruscotto';

  @override
  String get users => 'Utenti';

  @override
  String get settings => 'Impostazioni';

  @override
  String get logout => 'Disconnettersi';

  @override
  String get login => 'Accesso';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Accedi';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get welcomeBack => 'Bentornato';

  @override
  String get signInMessage => 'Accedi per accedere al portale.';

  @override
  String get requiredField => 'Obbligatorio';

  @override
  String get schoolName => 'Colegiul Național\n\"Vasile Goldiș\"';

  @override
  String get excellenceInEducation => 'Eccellenza nell\'istruzione';

  @override
  String get noDataToExport => 'Nessun dato da esportare';

  @override
  String get statsExportedSuccess =>
      'Statistiche esportate in CSV con successo';

  @override
  String get editProfessor => 'Modifica Professore';

  @override
  String get addProfessor => 'Aggiungi Professore';

  @override
  String get name => 'Nome';

  @override
  String get emailRequired => 'L\'email è obbligatoria';

  @override
  String get emailInvalid =>
      'L\'email deve essere nel formato: user@domain.com';

  @override
  String get newPassword => 'Nuova Password';

  @override
  String get passwordRequired => 'La password è obbligatoria';

  @override
  String get passwordMinLength => 'La password deve avere almeno 6 caratteri';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get add => 'Aggiungi';

  @override
  String get confirmDelete => 'Conferma Eliminazione';

  @override
  String deleteConfirmation(String name) {
    return 'Sei sicuro di voler eliminare $name?';
  }

  @override
  String get delete => 'Elimina';

  @override
  String get downloadApk => 'Scarica APK';

  @override
  String get debugConsole => 'Console di Debug';

  @override
  String get downloadCsv => 'Scarica CSV';

  @override
  String get professors => 'Professori';

  @override
  String get total => 'Totale';

  @override
  String get idGrowth => 'Crescita ID (Attività)';

  @override
  String get systemStatus => 'Stato del Sistema';

  @override
  String get logs => 'Registri';

  @override
  String get clearLogs => 'Cancella Registri';

  @override
  String get clearLogsConfirmation =>
      'Sei sicuro di voler cancellare tutti i registri?';

  @override
  String get clear => 'Cancella';

  @override
  String get searchLogs => 'Cerca registri...';

  @override
  String get all => 'Tutti';

  @override
  String get withInput => 'Con Input';

  @override
  String get withOutput => 'Con Output';

  @override
  String get stackTraces => 'Tracce dello Stack';

  @override
  String get noLogsMatch => 'Nessun registro corrisponde ai tuoi filtri';

  @override
  String get noLogsYet => 'Nessun registro ancora';

  @override
  String get input => 'Input';

  @override
  String get output => 'Output';

  @override
  String get trace => 'TRACCIA';

  @override
  String get fullMessage => 'Messaggio Completo';

  @override
  String get stackTrace => 'Traccia dello Stack';

  @override
  String copied(String title) {
    return '$title copiato';
  }
}
