import 'package:flutter/material.dart';
import 'package:asso_platform/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(texts.appTitle)),
      body: Center(
        child: Text(texts.welcomeHeadline,
            style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
