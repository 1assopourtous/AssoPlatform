import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../l10n/app_localizations.dart';

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
            const _FeaturedProjectsSection(),
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
    final t = AppLocalizations.of(context)!;
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final items = [
      _NavItem(t.home, '/'),
      _NavItem(t.categories, '/categories'),
      _NavItem('About', '/about'),
      _NavItem(t.contact, '/contact'),
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
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            icon: const Icon(Icons.login),
            label: Text(t.login),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Icons.app_registration),
            label: Text(t.signUp),
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
  final String route;
  const _NavItem(this.title, this.route);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, route),
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
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/catalog'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.explore),
                  label: Text(AppLocalizations.of(context)!.exploreNow),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/catalog'),
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

class _FeaturedProjectsSection extends StatelessWidget {
  const _FeaturedProjectsSection();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.featuredProjects,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 3 / 4,
            ),
            itemCount: 3,
            itemBuilder: (_, __) => const _ProjectCard(),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/about'),
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
                  Text('Project name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Category'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final Locale locale;
  final void Function(Locale) onLocaleChange;
  const _Footer({required this.locale, required this.onLocaleChange});

  void _showSocial(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name link tapped')),
    );
  }

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
              IconButton(
                onPressed: () => _showSocial(context, 'Facebook'),
                icon: const Icon(Icons.facebook),
              ),
              IconButton(
                onPressed: () => _showSocial(context, 'Twitter'),
                icon: const FaIcon(FontAwesomeIcons.twitter),
              ),
              IconButton(
                onPressed: () => _showSocial(context, 'Instagram'),
                icon: const FaIcon(FontAwesomeIcons.instagram),
              ),
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
