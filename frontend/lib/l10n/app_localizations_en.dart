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
}
