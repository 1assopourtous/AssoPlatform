import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.featuredProducts)),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 4,
        ),
        itemCount: 4,
        itemBuilder: (_, i) => Card(
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, '/about'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Ink.image(
                    image: NetworkImage('https://via.placeholder.com/200?text=Item'+i.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Item '+i.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
