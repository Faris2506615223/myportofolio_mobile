import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Kerangka yang sama menjaga navigasi, inset, dan tema kedua formulir konsisten.
class PortfolioFormScaffold extends StatelessWidget {
  final String title;
  final DrawerDestination destination;
  final Widget child;
  final VoidCallback? onToggleTheme;

  const PortfolioFormScaffold({
    super.key,
    required this.title,
    required this.destination,
    required this.child,
    this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canGoBack = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: canGoBack ? const BackButton() : null,
        actions: [
          if (canGoBack)
            Builder(
              builder: (scaffoldContext) => IconButton(
                onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                tooltip: 'Buka menu navigasi',
                icon: const Icon(Icons.menu),
              ),
            ),
          if (onToggleTheme != null)
            IconButton(
              onPressed: onToggleTheme,
              tooltip: isDark ? 'Aktifkan tema terang' : 'Aktifkan tema gelap',
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              ),
            ),
        ],
      ),
      drawer: LeftDrawer(
        destination: destination,
        onToggleTheme: onToggleTheme,
      ),
      body: SafeArea(child: child),
    );
  }
}
