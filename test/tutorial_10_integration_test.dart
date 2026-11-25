import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

void main() {
  test('Project serializes snake_case fields and excludes id from toJson', () {
    final fromJson = Project.fromJson({
      'id': '123e4567-e89b-12d3-a456-426614174000',
      'title': 'MyPortfolio',
      'description': 'Personal portfolio app',
      'tech_stack': 'Flutter, Django',
      'project_url': 'https://example.com',
      'project_image_url': null,
    });

    expect(fromJson.id, '123e4567-e89b-12d3-a456-426614174000');
    expect(fromJson.techStack, 'Flutter, Django');
    expect(fromJson.projectImageUrl, '');

    final json = fromJson.toJson();
    expect(json.containsKey('id'), isFalse);
    expect(json['tech_stack'], 'Flutter, Django');
    expect(json['project_url'], 'https://example.com');
    expect(json['project_image_url'], '');
  });

  test(
    'ApiClient handles getProjects, obtainToken, createProject, and logout',
    () async {
      final mockHttp = MockClient((request) async {
        if (request.url.path == '/api/v1/projects/' &&
            request.method == 'GET') {
          return http.Response(
            jsonEncode([
              {
                'id': 'uuid-1',
                'title': 'Project One',
                'description': 'First project',
                'tech_stack': 'Flutter',
                'project_url': 'https://example.com/one',
                'project_image_url': '',
              },
            ]),
            200,
          );
        }
        if (request.url.path == '/api/v1/auth/token/' &&
            request.method == 'POST') {
          return http.Response(jsonEncode({'token': 'abc-token'}), 200);
        }
        if (request.url.path == '/api/v1/projects/' &&
            request.method == 'POST') {
          expect(request.headers['Authorization'], 'Token abc-token');
          return http.Response(request.body, 201);
        }
        if (request.url.path == '/api/v1/auth/logout/' &&
            request.method == 'POST') {
          expect(request.headers['Authorization'], 'Token abc-token');
          return http.Response('', 204);
        }
        return http.Response('Bad request', 400);
      });

      final client = ApiClient(
        client: mockHttp,
        baseUrl: 'http://localhost:8000',
      );
      final projects = await client.getProjects();
      expect(projects, hasLength(1));
      expect(projects.first.title, 'Project One');

      final token = await client.obtainToken('owner', 'pass');
      expect(token, 'abc-token');

      final created = await client.createProject(
        const Project(
          title: 'Created',
          description: 'Desc',
          techStack: 'Dart',
          projectUrl: 'https://example.com/created',
        ),
        token: token,
      );
      expect(created.title, 'Created');

      await client.logout(token: token);
    },
  );

  test(
    'AuthState clears token on logout even if server returns ApiException',
    () async {
      final mockHttp = MockClient((request) async {
        if (request.url.path == '/api/v1/auth/token/') {
          return http.Response(jsonEncode({'token': 'tok-123'}), 200);
        }
        return http.Response('Unauthorized', 401);
      });

      final auth = AuthState(ApiClient(client: mockHttp));
      expect(auth.isLoggedIn, isFalse);

      await auth.login('owner', 'secret');
      expect(auth.isLoggedIn, isTrue);
      expect(auth.token, 'tok-123');

      await auth.logout();
      expect(auth.isLoggedIn, isFalse);
      expect(auth.token, isNull);
    },
  );

  testWidgets(
    'ProjectListScreen displays error + retry, empty state, and detail navigation',
    (tester) async {
      var callCount = 0;
      final mockHttp = MockClient((request) async {
        callCount++;
        if (callCount == 1) {
          return http.Response('Server Error', 500);
        }
        if (callCount == 2) {
          return http.Response(jsonEncode([]), 200);
        }
        return http.Response(
          jsonEncode([
            {
              'id': 'uuid-1',
              'title': 'Mobile App',
              'description': 'Flutter integrated with DRF',
              'tech_stack': 'Flutter, DRF',
              'project_url': 'https://example.com/app',
              'project_image_url': '',
            },
          ]),
          200,
        );
      });

      final client = ApiClient(client: mockHttp);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<ApiClient>.value(value: client),
            ChangeNotifierProvider<AuthState>(create: (_) => AuthState(client)),
          ],
          child: const MaterialApp(home: ProjectListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to load projects'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('No projects found.'), findsOneWidget);

      await tester.drag(find.text('No projects found.'), const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(find.text('Mobile App'), findsOneWidget);
      expect(find.text('Flutter, DRF'), findsOneWidget);

      await tester.tap(find.text('Mobile App'));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectDetailScreen), findsOneWidget);
      expect(find.text('https://example.com/app'), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    },
  );

  testWidgets(
    'ProjectDetailScreen renders image widget only when projectImageUrl is non-empty',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProjectDetailScreen(
            project: Project(
              title: 'With Image',
              description: 'Has image',
              techStack: 'Flutter',
              projectUrl: 'https://example.com',
              projectImageUrl: 'https://example.com/img.png',
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    },
  );

  testWidgets('LoginScreen validates inputs and shows SnackBar on 400/401', (
    tester,
  ) async {
    final mockHttp = MockClient((request) async {
      return http.Response('{"non_field_errors":["Unable to log in"]}', 400);
    });
    final client = ApiClient(client: mockHttp);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiClient>.value(value: client),
          ChangeNotifierProvider<AuthState>(create: (_) => AuthState(client)),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.text('Username cannot be empty!'), findsOneWidget);
    expect(find.text('Password cannot be empty!'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('login-username')),
      'wrong',
    );
    await tester.enterText(
      find.byKey(const ValueKey('login-password')),
      'wrong',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('400'), findsOneWidget);
  });
}
