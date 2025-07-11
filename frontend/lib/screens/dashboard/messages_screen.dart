import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = ['Alice', 'Bob', 'Charlie', 'Diana', 'Eva'];
    return Row(
      children: [
        SizedBox(
          width: 240,
          child: ListView(
            children: [
              for (final name in chats)
                ListTile(
                  leading: const CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://via.placeholder.com/50')),
                  title: Text(name),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Открыт чат с $name')),
                    );
                  },
                ),
            ],
          ),
        ),
        const VerticalDivider(width: 1),
        const Expanded(
          child: Center(child: Text('Выберите чат')), 
        )
      ],
    );
  }
}
