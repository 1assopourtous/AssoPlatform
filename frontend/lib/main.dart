import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'router.dart';
import 'services/push_service.dart';

/// Supabase URL и anon-key приходят через --dart-define при сборке
const supabaseUrl  = String.fromEnvironment('SUPABASE_URL');
const supabaseAnon = String.fromEnvironment('SUPABASE_ANON_KEY');

/// Firebase Web-конфиг — ваши реальные значения
const firebaseConfig = <String, String>{
  'apiKey'           : 'AIzaSyDEVTvnBG-bkTyOYEalPp_OE2kH5ONhIPA',
  'appId'            : '1:38538592671:web:bf4b31ff46387c73b8fdaa',
  'messagingSenderId': '38538592671',
  'projectId'        : 'assopourtous-3280d',
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 1. Supabase ────────────────────────────────────────────────
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnon);

  // ── 2. Push-уведомления (Firebase + FCM) ───────────────────────
  await PushService.init(firebaseConfig);

  // ── 3. Запуск приложения ──────────────────────────────────────
  runApp(const MyApp());
}

/*───────────────────────  UI  ───────────────────────*/

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router = createRouter();
  Locale _locale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Platform',
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
          ),
        ),
      ),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr')],
      routerConfig: _router,
      builder: (context, child) => Scaffold(
        body: Column(
          children: [
            _TopBar(
              locale: _locale,
              onLocaleChange: (loc) => setState(() => _locale = loc),
            ),
            Expanded(child: child ?? const SizedBox()),
          ],
        ),
      ),
    );
  }
}

/*──────────────────── Top Bar ─────────────────────*/

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
          const Text('Platform',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          const Spacer(),
          DropdownButton<Locale>(
            value: locale,
            underline: const SizedBox.shrink(),
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
