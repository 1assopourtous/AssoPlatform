import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.contact)),
      body: const Center(child: Text('Contact page')),
    );
  }
}
