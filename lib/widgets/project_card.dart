import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Kartu aksi mendukung sentuhan, fokus keyboard, tooltip, dan efek ripple.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final VoidCallback? onToggleTheme;

  const ItemCard(this.item, {super.key, this.onToggleTheme});

  Future<void> _handleTap(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    switch (item.action) {
      case HomepageAction.viewProjects:
        messenger
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
          );
        await navigator.push<void>(
          MaterialPageRoute<void>(
            builder: (_) => ProjectListScreen(onToggleTheme: onToggleTheme),
          ),
        );
      case HomepageAction.addProject:
        messenger
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
          );
        final loggedIn = await ensureLoggedIn(context);
        if (!loggedIn || !context.mounted) return;
        await navigator.push<void>(
          MaterialPageRoute<void>(
            builder: (_) => ProjectFormPage(onToggleTheme: onToggleTheme),
          ),
        );
      case HomepageAction.addExperience:
        messenger
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
          );
        await navigator.push<void>(
          MaterialPageRoute<void>(
            builder: (_) => ExperienceFormPage(onToggleTheme: onToggleTheme),
          ),
        );
      case HomepageAction.logout:
        final authState = context.read<AuthState>();
        if (authState.isLoggedIn) {
          await authState.logout();
          if (!context.mounted) return;
          messenger
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(content: Text('Kamu telah berhasil logout!')),
            );
        } else {
          messenger
            ..clearSnackBars()
            ..showSnackBar(const SnackBar(content: Text('Kamu belum login.')));
        }
      case HomepageAction.feedback:
        messenger
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(content: Text('Kamu telah menekan tombol ${item.name}!')),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);

    return Tooltip(
      message: item.description,
      child: Material(
        color: item.color,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => _handleTap(context),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(item.icon, color: Colors.white, size: 32),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_outward_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
