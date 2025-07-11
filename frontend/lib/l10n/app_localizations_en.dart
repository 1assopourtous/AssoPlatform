// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Platform';

  @override
  String get welcomeHeadline => 'Welcome to our platform!';

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
  String get home => 'Home';

  @override
  String get messages => 'Messages';

  @override
  String get myListings => 'My Listings';

  @override
  String get favorites => 'Favorites';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get searchHint => 'Search';

  @override
  String get whatDo => 'What do you want to do?';

  @override
  String get featuredProducts => 'Featured Products';

  @override
  String get recentAnnouncements => 'Recent Announcements';

  @override
  String get postProject => 'Post project';

  @override
  String get projectName => 'Project name';

  @override
  String get category => 'Category';

  @override
  String get location => 'Location';

  @override
  String get description => 'Description';

  @override
  String get selectChat => 'Select a chat to start messaging';
}
