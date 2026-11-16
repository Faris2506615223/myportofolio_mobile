import 'package:flutter/material.dart';

/// Kartu profil yang dapat digunakan ulang, dengan aksi opsional salin NPM.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final VoidCallback? onCopy;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: colors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (onCopy != null)
              IconButton(
                onPressed: onCopy,
                tooltip: 'Salin NPM',
                icon: const Icon(Icons.copy_rounded, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
