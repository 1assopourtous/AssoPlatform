// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Plateforme';

  @override
  String get welcomeHeadline => 'Bienvenue sur notre plateforme !';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get sendLink => 'Send magic link';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get noAccount => 'No account yet?';

  @override
  String get logIn => 'Log in';

  @override
  String get signUp => 'Sign up';

  @override
  String dashboardGreeting(Object email) {
    return 'Hello $email!';
  }

  @override
  String get aboutTitle => 'About us';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get login => 'Login';

  @override
  String get home => 'Accueil';

  @override
  String get messages => 'Messages';

  @override
  String get myListings => 'Mes annonces';

  @override
  String get favorites => 'Favoris';

  @override
  String get adminPanel => 'Admin';

  @override
  String get searchHint => 'Rechercher';

  @override
  String get whatDo => 'Que voulez-vous faire ?';

  @override
  String get featuredProducts => 'Produits vedettes';

  @override
  String get recentAnnouncements => 'Annonces récentes';

  @override
  String get featuredProjects => 'Projets mis en avant';

  @override
  String get categories => 'Catégories';

  @override
  String get contact => 'Contact';

  @override
  String get exploreNow => 'Découvrir';

  @override
  String get postProject => 'Publier un projet';

  @override
  String get projectName => 'Nom du projet';

  @override
  String get category => 'Catégorie';

  @override
  String get location => 'Lieu';

  @override
  String get description => 'Description';

  @override
  String get selectChat => 'Sélectionnez un chat pour commencer';
}
