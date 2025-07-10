// lib/services/jwt_service.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class JwtService {
  static const _secret = 'super_secret_platform_key';

  static String generateToken(String userId) {
    final payload = {
      'user_id': userId,
      'exp': DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    };
    final encoded = base64Url.encode(utf8.encode(jsonEncode(payload)));
    final signature = _sign(encoded);
    return '$encoded.$signature';
  }

  static String? validateToken(String token) {
    final parts = token.split('.');
    if (parts.length != 2) return null;

    final payloadEncoded = parts[0];
    final signature = parts[1];

    if (_sign(payloadEncoded) != signature) return null;

    final payload = jsonDecode(utf8.decode(base64Url.decode(payloadEncoded)));
    final exp = payload['exp'] as int?;
    if (exp == null || DateTime.now().millisecondsSinceEpoch ~/ 1000 > exp) {
      return null;
    }

    return payload['user_id'];
  }

  static String _sign(String input) {
    final hmac = Hmac(sha256, utf8.encode(_secret));
    return base64Url.encode(hmac.convert(utf8.encode(input)).bytes);
  }
}
