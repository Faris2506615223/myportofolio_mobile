import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

class _NavigationObserver extends NavigatorObserver {
  int pushes = 0;
  int replacements = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushes++;
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    replacements++;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

void main() {
  Future<void> pumpForm(
    WidgetTester tester, {
    Size? size,
    double scale = 1,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size ?? const Size(1000, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: const ProjectFormPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterField(WidgetTester tester, String key, String value) async {
    final field = find.byKey(ValueKey(key));
    await tester.ensureVisible(field);
    await tester.enterText(field, value);
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Save'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  Future<void> openDrawer(WidgetTester tester) async {
    tester.state<ScaffoldState>(find.byType(Scaffold).last).openDrawer();
    await tester.pumpAndSettle();
  }

  String fieldText(WidgetTester tester, String key) => tester
      .widget<EditableText>(
        find.descendant(
          of: find.byKey(ValueKey(key)),
          matching: find.byType(EditableText),
        ),
      )
      .controller
      .text;

  testWidgets('Drawer memakai pushReplacement tanpa menambah stack halaman', (
    tester,
  ) async {
    final observer = _NavigationObserver();
    await tester.pumpWidget(
      MaterialApp(navigatorObservers: [observer], home: const MyHomePage()),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('My Portfolio'), findsOneWidget);
    expect(
      find.text('Explore personal projects and experiences!'),
      findsOneWidget,
    );
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(observer.replacements, 1);
    expect(observer.pushes, 1);
    expect(
      Navigator.of(tester.element(find.byType(ProjectFormPage))).canPop(),
      isFalse,
    );

    await openDrawer(tester);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(observer.replacements, 2);
    expect(observer.pushes, 1);
  });

  testWidgets(
    'Kartu Tambah Proyek memakai push dan Back kembali ke menu yang sama',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      final homeElement = tester.element(find.byType(MyHomePage));
      await tester.ensureVisible(find.text('Tambah Proyek'));
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectFormPage), findsOneWidget);
      expect(
        find.text('Kamu telah menekan tombol Tambah Proyek!'),
        findsOneWidget,
      );
      expect(
        Navigator.of(tester.element(find.byType(ProjectFormPage))).canPop(),
        isTrue,
      );
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(MyHomePage)), same(homeElement));
    },
  );

  testWidgets('Validasi menolak nama dan deskripsi kosong termasuk spasi', (
    tester,
  ) async {
    await pumpForm(tester);
    await submit(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await enterField(tester, 'project-name', '   ');
    await enterField(tester, 'project-description', '\n   ');
    await submit(tester);
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('Dialog memuat lima isian dan OK mereset data serta kategori', (
    tester,
  ) async {
    await pumpForm(tester);
    await enterField(tester, 'project-name', '  Portofolio Faris  ');
    await enterField(
      tester,
      'project-description',
      'Aplikasi portofolio mobile.',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('project-category')));
    await tester.tap(find.byKey(const ValueKey('project-category')));
    await tester.pumpAndSettle();
    for (final category in [
      'Web Development',
      'Mobile Development',
      'Machine Learning',
      'Data Science',
      'Other',
    ]) {
      expect(find.text(category), findsWidgets);
    }
    await tester.tap(find.text('Mobile Development').last);
    await tester.pumpAndSettle();
    await enterField(tester, 'project-technologies', 'Flutter, Dart');
    await enterField(tester, 'project-link', 'https://example.com/portfolio');
    await submit(tester);

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(find.text('Nama Proyek: Portofolio Faris'), findsOneWidget);
    expect(find.text('Deskripsi: Aplikasi portofolio mobile.'), findsOneWidget);
    expect(find.text('Kategori: Mobile Development'), findsOneWidget);
    expect(find.text('Teknologi: Flutter, Dart'), findsOneWidget);
    expect(find.text('Tautan: https://example.com/portfolio'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    for (final key in [
      'project-name',
      'project-description',
      'project-technologies',
      'project-link',
    ]) {
      expect(fieldText(tester, key), isEmpty);
    }
    final dropdown = tester.state<FormFieldState<String>>(
      find.byKey(const ValueKey('project-category')),
    );
    expect(dropdown.value, 'Web Development');

    // Submit kedua membuktikan variabel dialog tidak menyimpan input lama.
    await enterField(tester, 'project-name', 'Proyek kedua');
    await enterField(tester, 'project-description', 'Deskripsi baru');
    await submit(tester);
    expect(find.text('Nama Proyek: Proyek kedua'), findsOneWidget);
    expect(find.text('Kategori: Web Development'), findsOneWidget);
    expect(find.text('Teknologi: '), findsOneWidget);
    expect(find.text('Tautan: '), findsOneWidget);
  });

  testWidgets('Menutup dialog dengan Back mempertahankan draf', (tester) async {
    await pumpForm(tester);
    await enterField(tester, 'project-name', 'Draf proyek');
    await enterField(tester, 'project-description', 'Deskripsi draf');
    await submit(tester);
    Navigator.of(tester.element(find.byType(AlertDialog))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(fieldText(tester, 'project-name'), 'Draf proyek');
    expect(fieldText(tester, 'project-description'), 'Deskripsi draf');
  });

  testWidgets('Tautan opsional menolak skema dan format yang tidak valid', (
    tester,
  ) async {
    await pumpForm(tester);
    await enterField(tester, 'project-name', 'Validasi tautan');
    await enterField(tester, 'project-description', 'Menguji input tautan');
    for (final link in [
      'javascript:alert(1)',
      'ftp://example.com',
      'bukan-url',
      'https://example .com',
    ]) {
      await enterField(tester, 'project-link', link);
      await submit(tester);
      expect(
        find.text('Gunakan URL HTTP atau HTTPS yang valid.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    }
    await enterField(tester, 'project-link', 'http://example.com/project');
    await submit(tester);
    expect(find.text('Tautan: http://example.com/project'), findsOneWidget);
  });

  testWidgets(
    'Memilih halaman aktif di drawer hanya menutup drawer tanpa membuang draf',
    (tester) async {
      await pumpForm(tester);
      await enterField(tester, 'project-name', 'Draf tetap ada');
      final formElement = tester.element(find.byType(ProjectFormPage));
      await openDrawer(tester);
      await tester.tap(find.text('Add Project'));
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(ProjectFormPage)), same(formElement));
      expect(fieldText(tester, 'project-name'), 'Draf tetap ada');
      expect(
        tester.state<ScaffoldState>(find.byType(Scaffold)).isDrawerOpen,
        isFalse,
      );
    },
  );

  testWidgets('Kontrol tema tetap tersedia setelah perpindahan lewat drawer', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await openDrawer(tester);
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Aktifkan tema gelap'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(ProjectFormPage))).brightness,
      Brightness.dark,
    );
    await openDrawer(tester);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Aktifkan tema terang'), findsOneWidget);
    await tester.tap(find.byTooltip('Aktifkan tema terang'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(MyHomePage))).brightness,
      Brightness.light,
    );
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets(
      'Form dan dialog dapat dipakai pada ${size.width}x${size.height}',
      (tester) async {
        await pumpForm(tester, size: size);
        await enterField(tester, 'project-name', 'Proyek responsif');
        await enterField(
          tester,
          'project-description',
          'Deskripsi proyek yang dapat digulir.',
        );
        await submit(tester);
        expect(find.text('Nama Proyek: Proyek responsif'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        await openDrawer(tester);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Add Project'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Form dan drawer tetap dapat dipakai dengan teks 200 persen', (
    tester,
  ) async {
    await pumpForm(tester, size: const Size(320, 568), scale: 2);
    expect(tester.takeException(), isNull);
    await enterField(tester, 'project-name', 'Proyek teks besar');
    await enterField(
      tester,
      'project-description',
      'Deskripsi yang panjang untuk menguji scroll pada dialog. ' * 10,
    );
    await submit(tester);
    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await openDrawer(tester);
    expect(find.text('Add Project'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Keyboard tidak menghalangi tombol Save pada layar kecil', (
    tester,
  ) async {
    await pumpForm(tester, size: const Size(390, 844));
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await enterField(tester, 'project-name', 'Proyek keyboard');
    await enterField(tester, 'project-description', 'Deskripsi keyboard');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await submit(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
