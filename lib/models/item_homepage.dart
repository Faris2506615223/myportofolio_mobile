import 'package:material_ui/material_ui.dart';

enum HomepageAction {
  feedback,
  viewProjects,
  addProject,
  addExperience,
  logout,
}

/// Konfigurasi immutable setiap aksi; warna tidak bergantung pada percabangan UI.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final HomepageAction action;

  const ItemHomepage({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    this.action = HomepageAction.feedback,
  });
}
