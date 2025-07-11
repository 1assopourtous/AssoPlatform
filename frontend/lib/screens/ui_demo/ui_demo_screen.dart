import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/ui_demo_scaffold.dart';

class UiDemoScreen extends StatefulWidget {
  const UiDemoScreen({super.key});

  @override
  State<UiDemoScreen> createState() => _UiDemoScreenState();
}

class _UiDemoScreenState extends State<UiDemoScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomePage(),
      const _MessagesPage(),
      const _MyListingsPage(),
      const _FavoritesPage(),
      const _AdminPlaceholder(),
    ];
    return UiDemoScaffold(
      index: _index,
      onIndexChanged: (i) => setState(() => _index = i),
      body: pages[_index],
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 3 : width > 600 ? 2 : 1;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.welcomeHeadline,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),
          Text(t.whatDo, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: crossAxisCount,
            childAspectRatio: 4 / 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              _ActionCard(Icons.shopping_cart, 'Buy items'),
              _ActionCard(Icons.sell, 'Sell items'),
              _ActionCard(Icons.design_services, 'Offer a service'),
              _ActionCard(Icons.room_service, 'Request service'),
              _ActionCard(Icons.people, 'Find help'),
              _ActionCard(Icons.more_horiz, 'More'),
            ],
          ),
          const SizedBox(height: 24),
          Text(t.featuredProducts,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (_, i) => const _ProductCard(),
          ),
          const SizedBox(height: 24),
          Text(t.recentAnnouncements,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Column(
            children: List.generate(3, (_) => const _AnnouncementCard()),
          ),
        ],
      ),
    );
  }
}
class _MessagesPage extends StatelessWidget {
  const _MessagesPage();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        SizedBox(
          width: 280,
          child: ListView(
            children: List.generate(
              5,
              (i) => ListTile(
                leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://via.placeholder.com/50')),
                title: Text('User $i'),
                subtitle: const Text('Last message'),
                onTap: () {},
              ),
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(t.selectChat),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Message',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _MyListingsPage extends StatelessWidget {
  const _MyListingsPage();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const _ProjectFormPage()),
              );
            },
            child: Text(t.postProject),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: List.generate(
                3,
                (i) => Card(
                  child: ListTile(
                    title: Text('My project $i'),
                    subtitle: const Text('Service'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FavoritesPage extends StatelessWidget {
  const _FavoritesPage();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Favorites'));
  }
}

class _AdminPlaceholder extends StatelessWidget {
  const _AdminPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Admin panel'));
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Ink.image(
                image: NetworkImage('https://via.placeholder.com/200'),
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Product name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Category'),
                  Text('\$42'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: const ListTile(
        leading: Icon(Icons.announcement_outlined),
        title: Text('Announcement title'),
        subtitle: Text('Some description goes here.'),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionCard(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectFormPage extends StatelessWidget {
  const _ProjectFormPage();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final categories = ['Design', 'Development', 'Marketing'];
    String category = categories.first;
    final nameCtl = TextEditingController();
    final locationCtl = TextEditingController();
    final descCtl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text(t.postProject)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: nameCtl,
              decoration: InputDecoration(labelText: t.projectName),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(labelText: t.category),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => category = v!,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: locationCtl,
              decoration: InputDecoration(labelText: t.location),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtl,
              maxLines: 3,
              decoration: InputDecoration(labelText: t.description),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(t.postProject),
              ),
            )
          ],
        ),
      ),
    );
  }
}
