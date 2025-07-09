import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  bool _isLoading = false;

    Future<void> _sendMagicLink() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final supabase = Supabase.instance.client;

    try {
        await supabase.auth.signInWithOtp(
        email: _emailCtl.text,
        emailRedirectTo: '${Uri.base.origin}/#/dashboard',
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Check your inbox for the magic link'),
        ));
    } on AuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
        );
    } finally {
        if (mounted) setState(() => _isLoading = false);
    }
    }


  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(t.email),
              TextFormField(
                controller: _emailCtl,
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Invalid email',
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _sendMagicLink, child: Text(t.sendLink)),
              TextButton(
                  onPressed: () => context.go('/'),
                  child: const Text('← Back')),
            ]),
          ),
        ),
      ),
    );
  }
}
