// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Pontaj Admin';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get users => 'Utilisateurs';

  @override
  String get settings => 'Paramètres';

  @override
  String get logout => 'Déconnexion';

  @override
  String get login => 'Connexion';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get signInMessage =>
      'Veuillez vous connecter pour accéder au portail.';

  @override
  String get requiredField => 'Obligatoire';

  @override
  String get schoolName => 'Colegiul Național\n\"Vasile Goldiș\"';

  @override
  String get excellenceInEducation => 'L\'excellence dans l\'éducation';

  @override
  String get noDataToExport => 'Aucune donnée à exporter';

  @override
  String get statsExportedSuccess =>
      'Statistiques exportées en CSV avec succès';

  @override
  String get editProfessor => 'Modifier le professeur';

  @override
  String get addProfessor => 'Ajouter un professeur';

  @override
  String get name => 'Nom';

  @override
  String get emailRequired => 'L\'email est requis';

  @override
  String get emailInvalid => 'L\'email doit être au format : user@domain.com';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get passwordRequired => 'Le mot de passe est requis';

  @override
  String get passwordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get add => 'Ajouter';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String deleteConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer $name ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get downloadApk => 'Télécharger l\'APK';

  @override
  String get debugConsole => 'Console de débogage';

  @override
  String get downloadCsv => 'Télécharger CSV';

  @override
  String get professors => 'Professeurs';

  @override
  String get total => 'Total';

  @override
  String get idGrowth => 'Croissance ID (Activité)';

  @override
  String get systemStatus => 'État du système';

  @override
  String get logs => 'Journaux';

  @override
  String get clearLogs => 'Effacer les journaux';

  @override
  String get clearLogsConfirmation =>
      'Êtes-vous sûr de vouloir effacer tous les journaux ?';

  @override
  String get clear => 'Effacer';

  @override
  String get searchLogs => 'Rechercher dans les journaux...';

  @override
  String get all => 'Tous';

  @override
  String get withInput => 'Avec entrée';

  @override
  String get withOutput => 'Avec sortie';

  @override
  String get stackTraces => 'Traces de pile';

  @override
  String get noLogsMatch => 'Aucun journal ne correspond à vos filtres';

  @override
  String get noLogsYet => 'Aucun journal pour le moment';

  @override
  String get input => 'Entrée';

  @override
  String get output => 'Sortie';

  @override
  String get trace => 'TRACE';

  @override
  String get fullMessage => 'Message complet';

  @override
  String get stackTrace => 'Trace de pile';

  @override
  String copied(String title) {
    return '$title copié';
  }
}
