import 'package:material_ui/material_ui.dart';

/// Konfigurasi immutable setiap aksi; warna tidak bergantung pada percabangan UI.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const ItemHomepage({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}
