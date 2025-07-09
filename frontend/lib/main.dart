import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'router.dart';
import 'services/push_service.dart';

const supabaseUrl  = String.fromEnvironment('SUPABASE_URL');
const supabaseAnon = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Supabase
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnon);

  // 2) Firebase + FCM (замените на реальные значения из консоли Firebase)
  await PushService.init(const {
    'apiKey':            'AIzaSyDEVTvnBG-bkTyOYEalPp_OE2kH5ONhIPA',
    'appId':             '1:38538592671:web:bf4b31ff46387c73b8fdaa',
    'messagingSenderId': '38538592671',
    'projectId':         'assopourtous-3280d',   // пример
  });

  // 3) Запуск приложения
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoRouter _router;
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _router = createRouter();
  }

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

class _TopBar extends StatelessWidget {
  final Locale locale;
  final void Function(Locale) onLocaleChange;
  const _TopBar({
    required this.locale,
    required this.onLocaleChange,
  });

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
            dropdownColor: Colors.white,
            underline: const SizedBox.shrink(),
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
