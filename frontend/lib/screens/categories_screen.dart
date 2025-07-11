import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.categories)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ListTile(leading: Icon(Icons.shopping_cart), title: Text('Buy items')),
          ListTile(leading: Icon(Icons.sell), title: Text('Sell items')),
          ListTile(leading: Icon(Icons.design_services), title: Text('Services')),
          ListTile(leading: Icon(Icons.volunteer_activism), title: Text('Volunteer')),
        ],
      ),
    );
  }
}
