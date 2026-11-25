import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app.dart';
import 'package:myportofolio_mobile/data/portfolio_data.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/info_card.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';
import 'package:provider/provider.dart';

void main() {
  ApiClient fakeApiClient() => ApiClient(
    client: MockClient((request) async {
      if (request.url.path == '/api/v1/projects/' && request.method == 'GET') {
        return http.Response(jsonEncode([]), 200);
      }
      if (request.url.path == '/api/v1/auth/token/') {
        return http.Response(jsonEncode({'token': 'test-token'}), 200);
      }
      if (request.url.path == '/api/v1/auth/logout/') {
        return http.Response('', 204);
      }
      return http.Response('Not found', 404);
    }),
  );

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 1100);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));
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
    expect(find.byType(ItemCard), findsNWidgets(4));
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

    expect(colors, hasLength(4));
  });

  testWidgets(
    'Keempat tombol mengarahkan aksi dan melindungi Tambah Proyek dengan login',
    (tester) async {
      await pumpApp(tester);

      // Lihat Proyek dapat diakses publik tanpa login
      await tester.ensureVisible(find.text('Lihat Proyek'));
      await tester.tap(find.text('Lihat Proyek'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectListScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Tambah Proyek mengarahkan ke LoginScreen saat belum login, lalu ke ProjectFormPage setelah login
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
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Tambah Pengalaman membuka ExperienceFormPage
      await tester.ensureVisible(find.text('Tambah Pengalaman'));
      await tester.tap(find.text('Tambah Pengalaman'));
      await tester.pumpAndSettle();
      expect(find.byType(ExperienceFormPage), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Logout saat sudah login mencabut token dan menampilkan SnackBar
      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      expect(find.text('Kamu telah berhasil logout!'), findsOneWidget);

      // Logout lagi saat sudah logout memberi pesan belum login
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      expect(find.text('Kamu belum login.'), findsOneWidget);
    },
  );

  testWidgets('Tap cepat mengganti pesan tanpa menyisakan antrean lama', (
    tester,
  ) async {
    await pumpApp(tester);

    for (final name in ['Logout', 'Tambah Pengalaman']) {
      await tester.tap(find.text(name));
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
    expect(
      find.text('Kamu telah menekan tombol Tambah Pengalaman!'),
      findsOneWidget,
    );
    expect(find.text('Kamu belum login.'), findsNothing);

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
      await tester.pumpWidget(MyApp(apiClient: fakeApiClient()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.ensureVisible(find.text('Logout'));
      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();
      expect(find.text('Kamu belum login.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Teks 200 persen tetap terbaca di layar kecil', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final apiClient = fakeApiClient();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: apiClient),
          ChangeNotifierProvider<AuthState>(
            create: (_) => AuthState(apiClient),
          ),
        ],
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const MyHomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Kamu belum login.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
