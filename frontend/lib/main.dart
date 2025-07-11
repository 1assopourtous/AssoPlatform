
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/login_screen.dart';
import 'screens/ui_demo/ui_demo_screen.dart';
import 'screens/landing/landing_screen.dart';
import 'services/jwt_service.dart';
import 'router.dart';
import 'l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _router = createRouter();
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final prefs = snapshot.data!;
        final token = prefs.getString('jwt_token');
        final userId = JwtService.validateToken(token ?? '');

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Platform',
          theme: ThemeData(
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(),
          ),
          locale: _locale,
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: userId != null
              ? Scaffold(
                  body: Column(
                    children: [
                      _TopBar(
                        locale: _locale,
                        onLocaleChange: (l) => setState(() => _locale = l),
                      ),
                      const Expanded(child: UiDemoScreen()),
                    ],
                  ),
                )
              : LandingScreen(
                  locale: _locale,
                  onLocaleChange: (l) => setState(() => _locale = l),
                ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  final Locale locale;
  final void Function(Locale) onLocaleChange;
  const _TopBar({required this.locale, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Platform',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const Spacer(),
          DropdownButton<Locale>(
            value: locale,
            dropdownColor: Colors.white,
            onChanged: (l) => onLocaleChange(l!),
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('EN')),
              DropdownMenuItem(value: Locale('fr'), child: Text('FR')),
            ],
          ),
        ],
      ),
    );
  }
}
