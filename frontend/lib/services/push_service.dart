import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PushService {
  /// Инициализация Firebase + отправка FCM-токена в таблицу `user_devices`
  static Future<void> init(Map<String, String> cfg) async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: cfg['apiKey']!,
        appId: cfg['appId']!,
        messagingSenderId: cfg['messagingSenderId']!,
        projectId: cfg['projectId']!,
      ),
    );

    final fcm = FirebaseMessaging.instance;

    // Запросить разрешение у пользователя
    await fcm.requestPermission();

    // Получить токен
    final token = await fcm.getToken();
    if (token == null) return;

    // Сохранить токен в Supabase
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      await Supabase.instance.client
          .from('user_devices')
          .upsert({'user_id': userId, 'fcm_token': token});
    }
  }
}
