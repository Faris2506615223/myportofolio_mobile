import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Kartu aksi mendukung sentuhan, fokus keyboard, tooltip, dan efek ripple.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  final VoidCallback? onToggleTheme;

  const ItemCard(this.item, {super.key, this.onToggleTheme});

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
          onTap: () {
            // Menghapus antrean mencegah pesan lama tampil setelah tap cepat.
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text('Kamu telah menekan tombol ${item.name}!'),
                ),
              );

            // push mempertahankan halaman menu untuk tombol Back.
            if (item.name == 'Tambah Proyek') {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) =>
                      ProjectFormPage(onToggleTheme: onToggleTheme),
                ),
              );
            }
          },
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
