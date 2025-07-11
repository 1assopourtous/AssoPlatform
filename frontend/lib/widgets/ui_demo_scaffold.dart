import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class UiDemoScaffold extends StatelessWidget {
  final int index;
  final ValueChanged<int> onIndexChanged;
  final Widget body;
  const UiDemoScaffold({
    required this.index,
    required this.onIndexChanged,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: t.searchHint,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage:
                NetworkImage('https://via.placeholder.com/64'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: index,
            onDestinationSelected: onIndexChanged,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home_outlined),
                label: Text(t.home),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(t.messages),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.list_alt),
                label: Text(t.myListings),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.favorite_border),
                label: Text(t.favorites),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                label: Text(t.adminPanel),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
