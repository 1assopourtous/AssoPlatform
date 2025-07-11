import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final announcements = [
      {'title': 'Looking for a plumber', 'description': 'Fix kitchen sink'},
      {'title': 'Selling bike', 'description': 'Almost new'},
      {'title': 'Volunteers needed', 'description': 'Community event'},
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: announcements.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final a = announcements[i];
        return ListTile(
          leading: const Icon(Icons.campaign_outlined),
          title: Text(a['title']!),
          subtitle: Text(a['description']!),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Отклик отправлен')),
            );
          },
        );
      },
    );
  }
}
