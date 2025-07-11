import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.contact)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.mail_outline, size: 80),
            SizedBox(height: 16),
            Text('Email: contact@assopourtous.com', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Phone: +33 123 456 789', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
