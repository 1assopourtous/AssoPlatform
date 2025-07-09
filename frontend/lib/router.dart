import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/welcome_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/about_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/admin/admin_screen.dart';   // новый

final _supabase = Supabase.instance.client;

GoRouter createRouter() => GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const WelcomeScreen()),
        GoRoute(path: '/about', builder: (_, __) => const AboutScreen()),
        GoRoute(
          path: '/auth',
          builder: (_, __) => const AuthScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (_, __) => const DashboardScreen(),
          redirect: (_, __) =>
              _supabase.auth.currentSession == null ? '/auth' : null,
        ),
            GoRoute(
          path: '/admin',
          builder: (_, __) => const AdminScreen(),
          redirect: (_, __) {
            final user = Supabase.instance.client.auth.currentUser;
            final role = user?.userMetadata?['role'];
            return role == 'admin' ? null : '/'; 
        },
            )
      ],
      errorBuilder: (_, __) => const NotFoundScreen(),
    );
