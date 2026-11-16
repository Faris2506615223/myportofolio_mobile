import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:myportofolio_mobile/data/portfolio_data.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:myportofolio_mobile/widgets/responsive_card_wrap.dart';

/// Halaman utama hanya merender konfigurasi; state tema dikelola oleh MyApp.
class MyHomePage extends StatelessWidget {
  final VoidCallback? onToggleTheme;

  const MyHomePage({super.key, this.onToggleTheme});

  Future<void> _copyNpm(BuildContext context) async {
    try {
      await Clipboard.setData(const ClipboardData(text: PortfolioData.npm));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(content: Text('NPM berhasil disalin.')));
    } on PlatformException {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(content: Text('NPM belum dapat disalin. Coba lagi.')),
        );
    }
  }

  void _showProfile(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tentang portofolio'),
        content: const SingleChildScrollView(
          child: Text(
            '${PortfolioData.name}\n'
            '${PortfolioData.npm} · ${PortfolioData.className}\n\n'
            'Mahasiswa Fakultas Ilmu Komputer, Universitas Indonesia. '
            'Portofolio ini menjadi ruang untuk mencatat karya dan '
            'perjalanan belajar pengembangan aplikasi.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (onToggleTheme != null)
            IconButton(
              onPressed: onToggleTheme,
              tooltip: isDark ? 'Aktifkan tema terang' : 'Aktifkan tema gelap',
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              ),
            ),
          IconButton(
            onPressed: () => _showProfile(context),
            tooltip: 'Tentang portofolio',
            icon: const Icon(Icons.info_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: LeftDrawer(onToggleTheme: onToggleTheme),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveCardWrap(
                      children: [
                        InfoCard(
                          title: 'NPM',
                          content: PortfolioData.npm,
                          icon: Icons.badge_outlined,
                          onCopy: () => _copyNpm(context),
                        ),
                        const InfoCard(
                          title: 'Name',
                          content: PortfolioData.name,
                          icon: Icons.person_outline_rounded,
                        ),
                        const InfoCard(
                          title: 'Class',
                          content: PortfolioData.className,
                          icon: Icons.school_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PORTOFOLIO / FARIS',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colors.onPrimaryContainer,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Selamat datang di MyPortfolio Mobile!',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: colors.onPrimaryContainer,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Halo, aku Faris. Setiap karya adalah bagian '
                            'dari perjalanan belajar. Mari tumbuh lewat '
                            'ide dan pengalaman baru.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colors.onPrimaryContainer,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Ruang karyaku',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Langkah kecil untuk cerita yang lebih besar.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ResponsiveCardWrap(
                      children: [
                        for (final item in PortfolioData.items)
                          ItemCard(item, onToggleTheme: onToggleTheme),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '${PortfolioData.name} · Universitas Indonesia',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
