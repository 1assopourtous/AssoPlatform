import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingScreen extends StatefulWidget {
  final Locale locale;
  final void Function(Locale) onLocaleChange;
  const LandingScreen({super.key, required this.locale, required this.onLocaleChange});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              locale: widget.locale,
              onLocaleChange: widget.onLocaleChange,
            ),
            _HeroSection(controller: _controller),
            const _AdvantagesSection(),
            const _CategoriesSection(),
            _Footer(
              locale: widget.locale,
              onLocaleChange: widget.onLocaleChange,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Locale locale;
  final void Function(Locale) onLocaleChange;
  const _Header({required this.locale, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final items = [
      _NavItem('Home'),
      _NavItem('Categories'),
      _NavItem('About'),
      _NavItem('Contact'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Text(
            'ASSOPLATRORN',
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          if (isDesktop)
            Row(children: items)
          else
            const SizedBox.shrink(),
          const SizedBox(width: 24),
          TextButton(
            onPressed: () {},
            child: const Text('Sign in'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Join now'),
          ),
          const SizedBox(width: 24),
          DropdownButton<Locale>(
            value: locale,
            underline: const SizedBox.shrink(),
            onChanged: (l) => onLocaleChange(l!),
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('EN')),
              DropdownMenuItem(value: Locale('fr'), child: Text('FR')),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  const _NavItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: TextButton(
          onPressed: () {},
          child: Text(title),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final ScrollController controller;
  const _HeroSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                final offset = controller.hasClients ? controller.offset : 0.0;
                return Transform.translate(
                  offset: Offset(0, offset * 0.2),
                  child: child,
                );
              },
              child: Image.network(
                'https://images.unsplash.com/photo-1522199710521-72d69614c702?auto=format&fit=crop&w=1600&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Connect. Share. Empower.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'A platform to buy, sell, volunteer and connect with your local community.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Explore Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdvantagesSection extends StatelessWidget {
  const _AdvantagesSection();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _Adv(icon: Icons.money_off, label: 'No fees'),
      _Adv(icon: Icons.security, label: 'Secure'),
      _Adv(icon: Icons.bolt, label: 'Built for scale'),
      _Adv(icon: Icons.groups, label: 'Community-driven'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: items,
      ),
    );
  }
}

class _Adv extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Adv({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 16)),
      ],
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    final categories = const [
      _Cat(icon: Icons.shopping_bag, label: 'Buy'),
      _Cat(icon: Icons.sell, label: 'Sell'),
      _Cat(icon: Icons.design_services, label: 'Services'),
      _Cat(icon: Icons.volunteer_activism, label: 'Volunteer'),
      _Cat(icon: Icons.workspaces, label: 'Projects'),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final crossAxisCount = width > 1000
              ? 5
              : width > 600
                  ? 3
                  : 2;
          return GridView.count(
            crossAxisCount: crossAxisCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1,
            children: categories,
          );
        },
      ),
    );
  }
}

class _Cat extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Cat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              Text(label, style: GoogleFonts.inter()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final Locale locale;
  final void Function(Locale) onLocaleChange;
  const _Footer({required this.locale, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ASSOPLATRORN',
              style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.facebook)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.twitter)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.instagram)),
              const Spacer(),
              DropdownButton<Locale>(
                value: locale,
                underline: const SizedBox.shrink(),
                onChanged: (l) => onLocaleChange(l!),
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('EN')),
                  DropdownMenuItem(value: Locale('fr'), child: Text('FR')),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
