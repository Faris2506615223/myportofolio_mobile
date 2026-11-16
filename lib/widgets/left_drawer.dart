import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

enum DrawerDestination { home, addProject }

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            selected: destination == DrawerDestination.addProject,
            onTap: () => _navigate(
              context,
              DrawerDestination.addProject,
              (context) => ProjectFormPage(onToggleTheme: onToggleTheme),
            ),
          ),
        ],
      ),
    );
  }
}
