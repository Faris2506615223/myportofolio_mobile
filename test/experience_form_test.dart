import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/models/item_homepage.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  Future<void> pumpForm(
    WidgetTester tester, {
    Size size = const Size(1000, 1000),
    double scale = 1,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: const ExperienceFormPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, String name, String value) async {
    final field = find.byKey(ValueKey('experience-$name'));
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.enterText(field, value);
    await tester.pumpAndSettle();
  }

  Future<void> press(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  Future<void> openDrawer(WidgetTester tester) async {
    tester.state<ScaffoldState>(find.byType(Scaffold).last).openDrawer();
    await tester.pumpAndSettle();
  }

  String textOf(WidgetTester tester, String name) => tester
      .widget<TextFormField>(find.byKey(ValueKey('experience-$name')))
      .controller!
      .text;

  testWidgets(
    'Kartu baru membuka form melalui push dan Back mengembalikan menu',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      final home = tester.element(find.byType(MyHomePage));
      await press(tester, 'Tambah Pengalaman');
      expect(find.byType(ExperienceFormPage), findsOneWidget);
      expect(
        find.text('Kamu telah menekan tombol Tambah Pengalaman!'),
        findsOneWidget,
      );
      expect(
        Navigator.of(tester.element(find.byType(ExperienceFormPage))).canPop(),
        isTrue,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(MyHomePage)), same(home));
    },
  );

  testWidgets(
    'Drawer membuka Experience, Home, dan Project tanpa kehilangan opsi lama',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await openDrawer(tester);
      for (final label in ['Home', 'Add Project', 'Add Experience']) {
        expect(find.text(label), findsOneWidget);
      }
      await tester.tap(find.text('Add Experience'));
      await tester.pumpAndSettle();
      expect(find.byType(ExperienceFormPage), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(ExperienceFormPage))).canPop(),
        isFalse,
      );
      await openDrawer(tester);
      await tester.tap(find.text('Add Project'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectFormPage), findsOneWidget);
      await openDrawer(tester);
      await tester.tap(find.text('Add Experience'));
      await tester.pumpAndSettle();
      await openDrawer(tester);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.byType(MyHomePage), findsOneWidget);
    },
  );

  testWidgets(
    'Pilihan drawer aktif mempertahankan draf dan tema tetap dapat diganti',
    (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      await openDrawer(tester);
      await tester.tap(find.text('Add Experience'));
      await tester.pumpAndSettle();
      await enter(tester, 'title', 'Draf pengalaman');
      await openDrawer(tester);
      await tester.tap(find.text('Add Experience'));
      await tester.pumpAndSettle();
      expect(textOf(tester, 'title'), 'Draf pengalaman');
      await tester.tap(find.byTooltip('Aktifkan tema gelap'));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(ExperienceFormPage))).brightness,
        Brightness.dark,
      );
      await openDrawer(tester);
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Aktifkan tema terang'), findsOneWidget);
    },
  );

  testWidgets(
    'Simpan menolak kosong, whitespace, serta judul yang terlalu panjang',
    (tester) async {
      await pumpForm(tester);
      await press(tester, 'Simpan');
      expect(
        find.text('Posisi atau kegiatan tidak boleh kosong!'),
        findsOneWidget,
      );
      expect(
        find.text('Deskripsi pengalaman tidak boleh kosong!'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
      await enter(tester, 'title', ' \t ');
      await enter(tester, 'description', '\n  ');
      await press(tester, 'Simpan');
      expect(find.byType(AlertDialog), findsNothing);
      await enter(tester, 'title', 'x' * 256);
      await enter(tester, 'description', 'Deskripsi valid');
      await press(tester, 'Simpan');
      expect(
        find.text('Posisi atau kegiatan maksimal 255 karakter.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
      await enter(tester, 'title', 'x' * 255);
      await press(tester, 'Simpan');
      expect(find.byType(AlertDialog), findsOneWidget);
    },
  );

  testWidgets(
    'Validasi thumbnail ditampilkan pada field dan diperbaiki sebelum dialog',
    (tester) async {
      await pumpForm(tester);
      await enter(tester, 'title', 'Asisten PBP');
      await enter(tester, 'description', 'Membantu sesi praktikum.');
      await enter(tester, 'thumbnail', 'javascript:alert(1)');
      await press(tester, 'Simpan');
      expect(
        find.text('Gunakan URL thumbnail HTTP atau HTTPS yang valid.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
      await enter(tester, 'thumbnail', "https://example.com/${'a' * 200}");
      await press(tester, 'Simpan');
      expect(find.text('URL thumbnail maksimal 200 karakter.'), findsOneWidget);
      await enter(tester, 'thumbnail', 'https://example.com/asisten.jpg');
      await press(tester, 'Simpan');
      expect(
        find.text('URL Thumbnail: https://example.com/asisten.jpg'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Dialog menampilkan semua isian terbaru dan Tutup mempertahankan form',
    (tester) async {
      await pumpForm(tester);
      await enter(tester, 'title', '  Relawan acara kampus  ');
      await enter(tester, 'description', 'Mengelola registrasi peserta.');
      final category = find.byKey(const ValueKey('experience-category'));
      await tester.ensureVisible(category);
      await tester.tap(category);
      await tester.pumpAndSettle();
      for (final label in ExperienceCategory.values.map(
        (value) => value.label,
      )) {
        expect(find.text(label), findsWidgets);
      }
      await tester.tap(find.text('Volunteer').last);
      await tester.pumpAndSettle();
      await press(tester, 'Simpan');
      expect(
        find.text('Posisi / Kegiatan: Relawan acara kampus'),
        findsOneWidget,
      );
      expect(
        find.text('Deskripsi Pengalaman: Mengelola registrasi peserta.'),
        findsOneWidget,
      );
      expect(find.text('Kategori: Volunteer'), findsOneWidget);
      expect(find.text('URL Thumbnail: Tidak diisi'), findsOneWidget);
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      expect(textOf(tester, 'title'), '  Relawan acara kampus  ');
      await enter(tester, 'title', 'Peran terbaru');
      await press(tester, 'Simpan');
      expect(find.text('Posisi / Kegiatan: Peran terbaru'), findsOneWidget);
      expect(
        find.text('Posisi / Kegiatan: Relawan acara kampus'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Isi contoh, penghitung karakter, dan Reset bekerja tanpa sisa error',
    (tester) async {
      await pumpForm(tester);
      await press(tester, 'Simpan');
      await press(tester, 'Isi contoh');
      expect(textOf(tester, 'title'), 'Kontributor Proyek Kuliah');
      expect(find.text('25/255 karakter'), findsOneWidget);
      await press(tester, 'Simpan');
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      await press(tester, 'Reset');
      for (final key in ['title', 'description', 'thumbnail']) {
        expect(textOf(tester, key), isEmpty);
      }
      expect(
        tester
            .state<FormFieldState<ExperienceCategory>>(
              find.byKey(const ValueKey('experience-category')),
            )
            .value,
        ExperienceCategory.fullTime,
      );
      expect(
        find.text('Posisi atau kegiatan tidak boleh kosong!'),
        findsNothing,
      );
      expect(
        find.text('Deskripsi pengalaman tidak boleh kosong!'),
        findsNothing,
      );
    },
  );

  testWidgets('Tujuan kartu bergantung pada action model, bukan nama tombol', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ItemCard(
            ItemHomepage(
              name: 'Catat riwayat',
              icon: Icons.work,
              color: Colors.purple,
              description: 'Buka pengalaman',
              action: HomepageAction.addExperience,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Catat riwayat'));
    await tester.pumpAndSettle();
    expect(find.byType(ExperienceFormPage), findsOneWidget);
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1440, 900),
  ]) {
    testWidgets(
      'Form pengalaman dapat digunakan pada ${size.width}x${size.height}',
      (tester) async {
        await pumpForm(tester, size: size);
        await press(tester, 'Isi contoh');
        await press(tester, 'Simpan');
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Tutup'));
        await tester.pumpAndSettle();
        await openDrawer(tester);
        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
        expect(find.byType(MyHomePage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Teks 200 persen dan dialog panjang tetap dapat digulir', (
    tester,
  ) async {
    await pumpForm(tester, size: const Size(320, 568), scale: 2);
    await enter(tester, 'title', 'Peran baru');
    await enter(tester, 'description', 'Deskripsi panjang pengalaman. ' * 50);
    await press(tester, 'Simpan');
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();
    await openDrawer(tester);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Simpan tetap terjangkau saat keyboard muncul', (tester) async {
    await pumpForm(tester, size: const Size(390, 844));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await enter(tester, 'title', 'Peran dengan keyboard');
    await enter(tester, 'description', 'Deskripsi valid.');
    await press(tester, 'Simpan');
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
