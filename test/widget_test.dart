import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets(
    'MyPortfolio displays profile cards, menu items, and snackbar feedback',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('MyPortfolio'), findsOneWidget);
      expect(find.text('NPM'), findsOneWidget);
      expect(find.text('2406000001'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Burhan'), findsOneWidget);
      expect(find.text('Class'), findsOneWidget);
      expect(find.text('PBP A'), findsOneWidget);
      expect(
        find.text('Selamat datang di MyPortfolio Mobile!'),
        findsOneWidget,
      );

      expect(find.text('Lihat Proyek'), findsOneWidget);
      expect(find.text('Tambah Proyek'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.byIcon(Icons.folder), findsOneWidget);
      expect(find.byIcon(Icons.add_circle), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);

      await tester.tap(find.text('Lihat Proyek'));
      await tester.pump();
      expect(
        find.text('Kamu telah menekan tombol Lihat Proyek!'),
        findsOneWidget,
      );

      await tester.tap(find.text('Tambah Proyek'));
      await tester.pump();
      expect(
        find.text('Kamu telah menekan tombol Tambah Proyek!'),
        findsOneWidget,
      );

      await tester.tap(find.text('Logout'));
      await tester.pump();
      expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
    },
  );
}
