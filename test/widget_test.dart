import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/app.dart';
import 'package:myportofolio_mobile/data/portfolio_data.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/item_card.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Profil memakai identitas pemilik, bukan data tutorial', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(tester.widget(find.byType(MyHomePage)), isA<StatelessWidget>());
    expect(find.byType(InfoCard), findsNWidgets(3));
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('2506615223'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Faris Salman Azhari'), findsOneWidget);
    expect(find.text('Class'), findsOneWidget);
    expect(find.text('PBP F'), findsOneWidget);
    expect(find.text('Burhan'), findsNothing);
    expect(find.text('2406000001'), findsNothing);
    expect(find.byType(ItemCard), findsNWidgets(3));
  });

  testWidgets('Setiap kartu aksi merender warna unik dari model', (
    tester,
  ) async {
    await pumpApp(tester);
    final colors = <Color>{};

    for (final item in PortfolioData.items) {
      final card = find.ancestor(
        of: find.text(item.name),
        matching: find.byType(ItemCard),
      );
      final material = tester.widget<Material>(
        find.descendant(of: card, matching: find.byType(Material)),
      );
      expect(material.color, item.color);
      colors.add(material.color!);
    }

    expect(colors, hasLength(3));
  });

  testWidgets('Ketiga tombol menampilkan pesan SnackBar yang persis sesuai', (
    tester,
  ) async {
    await pumpApp(tester);

    for (final item in PortfolioData.items) {
      await tester.ensureVisible(find.text(item.name));
      await tester.tap(find.text(item.name));
      await tester.pumpAndSettle();
      expect(
        find.text('Kamu telah menekan tombol ${item.name}!'),
        findsOneWidget,
      );
      expect(find.byType(SnackBar), findsOneWidget);
    }
  });

  testWidgets('Tap cepat mengganti pesan tanpa menyisakan antrean lama', (
    tester,
  ) async {
    await pumpApp(tester);

    for (final item in PortfolioData.items) {
      await tester.tap(find.text(item.name));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
    expect(find.text('Kamu telah menekan tombol Lihat Proyek!'), findsNothing);
    expect(find.text('Kamu telah menekan tombol Tambah Proyek!'), findsNothing);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('Salin NPM mengirim nilai yang benar ke clipboard', (
    tester,
  ) async {
    String? copiedText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copiedText = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Salin NPM'));
    await tester.pumpAndSettle();
    expect(copiedText, '2506615223');
    expect(find.text('NPM berhasil disalin.'), findsOneWidget);
  });

  testWidgets('Kegagalan clipboard memberi umpan balik tanpa crash', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          throw PlatformException(code: 'clipboard_unavailable');
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Salin NPM'));
    await tester.pumpAndSettle();
    expect(find.text('NPM belum dapat disalin. Coba lagi.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tema mengikuti sistem lalu dapat diganti dua arah', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await pumpApp(tester);

    Brightness brightness() =>
        Theme.of(tester.element(find.byType(MyHomePage))).brightness;

    expect(brightness(), Brightness.dark);
    await tester.tap(find.byTooltip('Aktifkan tema terang'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);
    await tester.tap(find.byTooltip('Aktifkan tema gelap'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);
  });

  testWidgets('Dialog profil dapat dibuka dan ditutup', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byTooltip('Tentang portofolio'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.textContaining('2506615223 · PBP F'), findsOneWidget);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(768, 1024),
    const Size(1024, 600),
    const Size(1440, 900),
  ]) {
    testWidgets('Layout ${size.width}x${size.height} tidak overflow', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Teks 200 persen tetap terbaca di layar kecil', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: const MyHomePage(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
