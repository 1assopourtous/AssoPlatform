import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.categories)),
      body: const Center(child: Text('Categories page')),
    );
  }
}
