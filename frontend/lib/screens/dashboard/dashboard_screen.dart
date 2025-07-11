import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/data_service.dart';
import '../../services/user_service.dart';
import 'market_screen.dart';
import 'projects_screen.dart';
import 'announcements_screen.dart';
import 'messages_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 1;
  String? role;
  String? userEmail;
  Map<String, dynamic>? wallet;
  List<dynamic> transactions = [];
  List<dynamic> notifications = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      try {
        final payloadEncoded = token.split('.')[1];
        final payload = json.decode(
            utf8.decode(base64Url.decode(base64Url.normalize(payloadEncoded))));
        role = payload['role'] ?? 'member';
        userEmail = payload['email'];
        wallet = await DataService.wallet(token);
        transactions = await DataService.transactions(token);
        notifications = await DataService.notifications(token);
      } catch (e, st) {
        _error = 'Ошибка загрузки данных';
        debugPrint('Dashboard load error: $e\n$st');
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      if (_error != null) {
        return Scaffold(
          body: Center(child: Text(_error!)),
        );
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      const _ProfileView(),
      _BalanceView(wallet: wallet),
      _HistoryView(list: transactions),
      _NotificationsView(list: notifications, onRead: _markRead),
      const MarketScreen(),
      const ProjectsScreen(),
      const AnnouncementsScreen(),
      const MessagesScreen(),
      const _SettingsView(),
      if (role == 'admin') const _AdminView(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $userEmail!'),
        backgroundColor: const Color(0xFF27ae60),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () => setState(() => _index = 3),
              ),
              if (notifications.any((n) => n['is_read'] == 0))
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                )
            ],
          )
        ],
      ),
      drawer: _SideNav(
        selected: _index,
        isAdmin: role == 'admin',
        onSelect: (i) => setState(() => _index = i),
      ),
      body: pages[_index],
    );
  }

  Future<void> _markRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token')!;
    await DataService.markRead(id, token);
    await _loadData();
  }
}

class _SideNav extends StatelessWidget {
  final int selected;
  final bool isAdmin;
  final ValueChanged<int> onSelect;
  const _SideNav({required this.selected, required this.onSelect, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final items = [
      const _NavItem(icon: Icons.person, label: 'Профиль'),
      const _NavItem(icon: Icons.account_balance_wallet, label: 'Баланс'),
      const _NavItem(icon: Icons.history, label: 'История'),
      const _NavItem(icon: Icons.notifications, label: 'Уведомления'),
      const _NavItem(icon: Icons.storefront, label: 'Маркет'),
      const _NavItem(icon: Icons.work, label: 'Проекты'),
      const _NavItem(icon: Icons.campaign, label: 'Объявления'),
      const _NavItem(icon: Icons.chat, label: 'Сообщения'),
      const _NavItem(icon: Icons.settings, label: 'Настройки'),
    ];
    if (isAdmin) items.add(const _NavItem(icon: Icons.admin_panel_settings, label: 'Участники'));
    return Drawer(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            leading: Icon(item.icon, color: selected == index ? const Color(0xFF27ae60) : null),
            title: Text(item.label),
            selected: selected == index,
            onTap: () {
              Navigator.pop(context);
              onSelect(index);
            },
          );
        },
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _BalanceView extends StatelessWidget {
  final Map<String, dynamic>? wallet;
  const _BalanceView({this.wallet});

  @override
  Widget build(BuildContext context) {
    final balance = wallet?['balance'] ?? 0;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF27ae60),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '\$${balance.toString()}',
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _HistoryView extends StatelessWidget {
  final List<dynamic> list;
  const _HistoryView({required this.list});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const Center(child: Text('Нет транзакций'));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final tx = list[index];
        return ListTile(
          title: Text('${tx['type']} \$${tx['amount']}'),
          subtitle: Text(tx['created_at'] ?? ''),
        );
      },
    );
  }
}

class _NotificationsView extends StatelessWidget {
  final List<dynamic> list;
  final Future<void> Function(String id) onRead;
  const _NotificationsView({required this.list, required this.onRead});

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) return const Center(child: Text('Нет уведомлений'));
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final n in list)
          Card(
            child: ListTile(
              title: Text(n['title'] ?? ''),
              subtitle: Text(n['body'] ?? ''),
              trailing: n['is_read'] == 1
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () => onRead(n['id'] as String),
                    ),
            ),
          )
      ],
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Профиль'));
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Настройки'));
  }
}

class _AdminView extends StatelessWidget {
  const _AdminView();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: UserService.fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) return const SizedBox.shrink();
        final users = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final u = users[index];
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(u.name),
              subtitle: Text(u.email),
              trailing: Text('\$${u.balance}'),
            );
          },
        );
      },
    );
  }
}
