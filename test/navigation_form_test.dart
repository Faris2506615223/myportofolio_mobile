import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

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
  ApiClient fakeApiClient({
    int postStatus = 201,
    Map<String, dynamic>? lastPostBody,
  }) => ApiClient(
    client: MockClient((request) async {
      if (request.url.path == '/api/v1/auth/token/') {
        return http.Response(jsonEncode({'token': 'valid-token'}), 200);
      }
      if (request.url.path == '/api/v1/auth/logout/') {
        return http.Response('', 204);
      }
      if (request.url.path == '/api/v1/projects/' && request.method == 'POST') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        lastPostBody?.addAll(body);
        if (postStatus >= 200 && postStatus < 300) {
          return http.Response(
            jsonEncode({
              'id': 'uuid-created',
              'title': body['title'],
              'description': body['description'],
              'tech_stack': body['tech_stack'],
              'project_url': body['project_url'],
              'project_image_url': body['project_image_url'] ?? '',
            }),
            postStatus,
          );
        }
        return http.Response('{"detail":"error"}', postStatus);
      }
      return http.Response('[]', 200);
    }),
  );

  Future<void> pumpForm(
    WidgetTester tester, {
    Size? size,
    double scale = 1,
    String? initialToken = 'valid-token',
    ApiClient? apiClient,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size ?? const Size(1000, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final client = apiClient ?? fakeApiClient();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: client),
          ChangeNotifierProvider<AuthState>(
            create: (_) => AuthState(client, initialToken: initialToken),
          ),
        ],
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          ),
          home: const ProjectFormPage(),
        ),
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
    final client = fakeApiClient();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: client),
          ChangeNotifierProvider<AuthState>(
            create: (_) => AuthState(client, initialToken: 'valid-token'),
          ),
        ],
        child: MaterialApp(
          navigatorObservers: [observer],
          home: const MyHomePage(),
        ),
      ),
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
    'Kartu Tambah Proyek memerlukan login lalu membuka form dengan push dan Back kembali ke menu',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));
      await tester.pumpAndSettle();
      final homeElement = tester.element(find.byType(MyHomePage));
      await tester.ensureVisible(find.text('Tambah Proyek'));
      await tester.tap(find.text('Tambah Proyek'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('login-username')),
        'owner',
      );
      await tester.enterText(
        find.byKey(const ValueKey('login-password')),
        'secret',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectFormPage), findsOneWidget);
      expect(
        Navigator.of(tester.element(find.byType(ProjectFormPage))).canPop(),
        isTrue,
      );
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(MyHomePage)), same(homeElement));
    },
  );

  testWidgets(
    'Validasi menolak Title, Description, Tech Stack, dan Project URL kosong termasuk spasi',
    (tester) async {
      await pumpForm(tester);
      await submit(tester);
      expect(find.text('Title cannot be empty!'), findsOneWidget);
      expect(find.text('Description cannot be empty!'), findsOneWidget);
      expect(find.text('Tech Stack cannot be empty!'), findsOneWidget);
      expect(find.text('Project URL cannot be empty!'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);

      await enterField(tester, 'project-title', '   ');
      await enterField(tester, 'project-description', '\n   ');
      await enterField(tester, 'project-tech-stack', '  ');
      await enterField(tester, 'project-url', '  ');
      await submit(tester);
      expect(find.text('Title cannot be empty!'), findsOneWidget);
      expect(find.text('Description cannot be empty!'), findsOneWidget);
      expect(find.text('Tech Stack cannot be empty!'), findsOneWidget);
      expect(find.text('Project URL cannot be empty!'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'Submit POST mengirim field ProjectSerializer dan OK pada AlertDialog mereset form',
    (tester) async {
      final capturedBody = <String, dynamic>{};
      await pumpForm(
        tester,
        apiClient: fakeApiClient(lastPostBody: capturedBody),
      );
      await enterField(tester, 'project-title', '  Portofolio Faris  ');
      await enterField(
        tester,
        'project-description',
        'Aplikasi portofolio mobile.',
      );
      await enterField(tester, 'project-tech-stack', 'Flutter, Django');
      await enterField(tester, 'project-url', 'https://example.com/portfolio');
      await enterField(
        tester,
        'project-image-url',
        'https://example.com/cover.png',
      );
      await submit(tester);

      expect(capturedBody['title'], 'Portofolio Faris');
      expect(capturedBody['description'], 'Aplikasi portofolio mobile.');
      expect(capturedBody['tech_stack'], 'Flutter, Django');
      expect(capturedBody['project_url'], 'https://example.com/portfolio');
      expect(
        capturedBody['project_image_url'],
        'https://example.com/cover.png',
      );

      expect(find.text('Project successfully created!'), findsOneWidget);
      expect(find.text('Title: Portofolio Faris'), findsOneWidget);
      expect(
        find.text('Description: Aplikasi portofolio mobile.'),
        findsOneWidget,
      );
      expect(find.text('Tech Stack: Flutter, Django'), findsOneWidget);
      expect(
        find.text('Project URL: https://example.com/portfolio'),
        findsOneWidget,
      );
      expect(
        find.text('Project Image URL: https://example.com/cover.png'),
        findsOneWidget,
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      for (final key in [
        'project-title',
        'project-description',
        'project-tech-stack',
        'project-url',
        'project-image-url',
      ]) {
        expect(fieldText(tester, key), isEmpty);
      }
    },
  );

  testWidgets('401 saat submit melakukan logout dan meminta login ulang', (
    tester,
  ) async {
    await pumpForm(tester, apiClient: fakeApiClient(postStatus: 401));
    await enterField(tester, 'project-title', 'Proyek 401');
    await enterField(tester, 'project-description', 'Deskripsi');
    await enterField(tester, 'project-tech-stack', 'Dart');
    await enterField(tester, 'project-url', 'https://example.com');
    await submit(tester);

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Session expired. Please login again.'), findsOneWidget);
  });

  testWidgets('Validasi URL menolak skema dan format tidak valid', (
    tester,
  ) async {
    await pumpForm(tester);
    await enterField(tester, 'project-title', 'Validasi tautan');
    await enterField(tester, 'project-description', 'Menguji input tautan');
    await enterField(tester, 'project-tech-stack', 'Flutter');
    for (final link in [
      'javascript:alert(1)',
      'ftp://example.com',
      'bukan-url',
      'https://example .com',
    ]) {
      await enterField(tester, 'project-url', link);
      await submit(tester);
      expect(
        find.text('Please enter a valid HTTP or HTTPS URL.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    }
    await enterField(tester, 'project-url', 'http://example.com/project');
    await submit(tester);
    expect(
      find.text('Project URL: http://example.com/project'),
      findsOneWidget,
    );
  });

  testWidgets(
    'Memilih halaman aktif di drawer hanya menutup drawer tanpa membuang draf',
    (tester) async {
      await pumpForm(tester);
      await enterField(tester, 'project-title', 'Draf tetap ada');
      final formElement = tester.element(find.byType(ProjectFormPage));
      await openDrawer(tester);
      await tester.tap(find.text('Add Project'));
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(ProjectFormPage)), same(formElement));
      expect(fieldText(tester, 'project-title'), 'Draf tetap ada');
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
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));
    await tester.pumpAndSettle();
    await openDrawer(tester);
    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('login-username')),
      'owner',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password')),
      'secret',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
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
        await enterField(tester, 'project-title', 'Proyek responsif');
        await enterField(
          tester,
          'project-description',
          'Deskripsi proyek yang dapat digulir.',
        );
        await enterField(tester, 'project-tech-stack', 'Flutter');
        await enterField(tester, 'project-url', 'https://example.com');
        await submit(tester);
        expect(find.text('Title: Proyek responsif'), findsOneWidget);
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
    await enterField(tester, 'project-title', 'Proyek teks besar');
    await enterField(
      tester,
      'project-description',
      'Deskripsi yang panjang untuk menguji scroll pada dialog. ' * 10,
    );
    await enterField(tester, 'project-tech-stack', 'Flutter');
    await enterField(tester, 'project-url', 'https://example.com');
    await submit(tester);
    expect(find.text('Project successfully created!'), findsOneWidget);
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
    await enterField(tester, 'project-title', 'Proyek keyboard');
    await enterField(tester, 'project-description', 'Deskripsi keyboard');
    await enterField(tester, 'project-tech-stack', 'Flutter');
    await enterField(tester, 'project-url', 'https://example.com');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await submit(tester);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
