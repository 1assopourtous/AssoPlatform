import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const _apiKey = String.fromEnvironment('RESEND_API_KEY'); // добавить в Pages env

  static Future<void> send({
    required String to,
    required String subject,
    required String html,
  }) async {
    if (_apiKey.isEmpty) {
      // MOCK
      // ignore: avoid_print
      print('[MOCK EMAIL] To:$to  Subj:$subject');
      return;
    }
    final res = await http.post(
      Uri.parse('https://api.resend.com/emails'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'from'   : 'noreply@assopourtous.com',
        'to'     : to,
        'subject': subject,
        'html'   : html,
      }),
    );
    // обработка ошибок опущена
  }
}
