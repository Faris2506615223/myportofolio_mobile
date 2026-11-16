import 'package:material_ui/material_ui.dart';

/// Menghitung lebar dari ruang induk, bukan dari lebar layar keseluruhan.
/// Teks yang diperbesar memakai satu kolom agar konten tetap terbaca utuh.
class ResponsiveCardWrap extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveCardWrap({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        final largeText = MediaQuery.textScalerOf(context).scale(14) > 20;
        final columns = constraints.maxWidth >= 780 && !largeText
            ? (children.length == 4 ? 2 : 3)
            : 1;
        final width =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}
