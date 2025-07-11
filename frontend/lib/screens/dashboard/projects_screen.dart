import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = [
      {'name': 'Community Cleanup', 'category': 'Volunteer'},
      {'name': 'Tech Workshop', 'category': 'Education'},
      {'name': 'Charity Run', 'category': 'Sport'},
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Функция недоступна')),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Создать проект'),
        ),
        const SizedBox(height: 16),
        for (final p in projects)
          Card(
            child: ListTile(
              title: Text(p['name']!),
              subtitle: Text(p['category']!),
            ),
          )
      ],
    );
  }
}
