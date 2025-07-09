import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(child: Text(t.pageNotFound, style: const TextStyle(fontSize: 24))),
    );
  }
}
