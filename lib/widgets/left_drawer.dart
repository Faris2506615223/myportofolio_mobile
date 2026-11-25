import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

enum DrawerDestination { home, projects, addProject, addExperience }

/// Drawer mengganti route aktif; kartu Tambah Proyek memakai push secara terpisah.
class LeftDrawer extends StatelessWidget {
  final DrawerDestination destination;
  final VoidCallback? onToggleTheme;

  const LeftDrawer({
    super.key,
    this.destination = DrawerDestination.home,
    this.onToggleTheme,
  });

  void _navigate(
    BuildContext context,
    DrawerDestination target,
    WidgetBuilder builder,
  ) {
    final navigator = Navigator.of(context);
    // Tutup drawer (local history) sebelum mengganti route halaman.
    navigator.pop();
    if (target == destination) return;
    navigator.pushReplacement<void, void>(
      MaterialPageRoute<void>(builder: builder),
    );
  }

  Future<void> _navigateProtected(
    BuildContext context,
    DrawerDestination target,
    WidgetBuilder builder,
  ) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    if (target == destination) return;

    final loggedIn = await ensureLoggedIn(navigator.context);
    if (!loggedIn || !navigator.mounted) return;
    navigator.pushReplacement<void, void>(
      MaterialPageRoute<void>(builder: builder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colors.primary),
            // Header juga dapat digulir saat ukuran teks sistem diperbesar.
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Explore personal projects and experiences!',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colors.onPrimary),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selected: destination == DrawerDestination.home,
            onTap: () => _navigate(
              context,
              DrawerDestination.home,
              (context) => MyHomePage(onToggleTheme: onToggleTheme),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Projects'),
            selected: destination == DrawerDestination.projects,
            onTap: () => _navigate(
              context,
              DrawerDestination.projects,
              (context) => ProjectListScreen(onToggleTheme: onToggleTheme),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            selected: destination == DrawerDestination.addProject,
            onTap: () => _navigateProtected(
              context,
              DrawerDestination.addProject,
              (context) => ProjectFormPage(onToggleTheme: onToggleTheme),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.work_outline_rounded),
            title: const Text('Add Experience'),
            selected: destination == DrawerDestination.addExperience,
            onTap: () => _navigate(
              context,
              DrawerDestination.addExperience,
              (context) => ExperienceFormPage(onToggleTheme: onToggleTheme),
            ),
          ),
          const Divider(),
          if (!isLoggedIn)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () async {
                final navigator = Navigator.of(context);
                navigator.pop();
                await ensureLoggedIn(navigator.context);
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                final authState = context.read<AuthState>();
                navigator.pop();
                await authState.logout();
                messenger
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(content: Text('Logged out successfully.')),
                  );
              },
            ),
        ],
      ),
    );
  }
}
