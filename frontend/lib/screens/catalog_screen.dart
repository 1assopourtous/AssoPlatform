import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.featuredProducts)),
      body: const Center(child: Text('Catalog page')),
    );
  }
}
