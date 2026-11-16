import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';

/// Identitas disamakan dengan README proyek portofolio Django milik pengguna.
abstract final class PortfolioData {
  static const npm = '2506615223';
  static const name = 'Faris Salman Azhari';
  static const className = 'PBP F';

  static const items = <ItemHomepage>[
    ItemHomepage(
      name: 'Lihat Proyek',
      icon: Icons.folder,
      color: Color(0xFF2457A7),
      description: 'Jelajahi karya dan perjalanan belajarku.',
    ),
    ItemHomepage(
      name: 'Tambah Proyek',
      icon: Icons.add_circle,
      color: Color(0xFF176B4F),
      description: 'Mulai langkah baru dengan ide berikutnya.',
    ),
    ItemHomepage(
      name: 'Logout',
      icon: Icons.logout,
      color: Color(0xFFB3452F),
      description: 'Sampai jumpa di kesempatan berikutnya.',
    ),
  ];
}
