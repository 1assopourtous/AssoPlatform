// frontend/lib/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/about_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/admin/admin_screen.dart';
import 'screens/ui_demo/ui_demo_screen.dart';

/// Создаём общий роутер приложения
GoRouter createRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/',        builder: (_, __) => const WelcomeScreen()),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(path: '/about',   builder: (_, __) => const AboutScreen()),
        GoRoute(
          path: '/admin',
          builder: (_, __) => const AdminScreen(),
        ),
        GoRoute(
          path: '/demo',
          builder: (_, __) => const UiDemoScreen(),
        ),
      ],
      errorBuilder: (_, __) => const NotFoundScreen(),
    );
 