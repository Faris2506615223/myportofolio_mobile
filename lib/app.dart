import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/theme.dart';
import 'package:provider/provider.dart';

/// Menyimpan pilihan tema serta menyediakan ApiClient dan AuthState di root.
class MyApp extends StatefulWidget {
  const MyApp({this.apiClient, super.key});

  final ApiClient? apiClient;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  late final ApiClient _apiClient = widget.apiClient ?? ApiClient();

  void _toggleTheme() {
    final isDark = switch (_themeMode) {
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark,
      ThemeMode.dark => true,
      ThemeMode.light => false,
    };

    setState(() {
      _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>.value(value: _apiClient),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState(_apiClient)),
      ],
      child: MaterialApp(
        title: 'MyPortfolio | Faris Salman Azhari',
        debugShowCheckedModeBanner: false,
        theme: portfolioTheme(Brightness.light),
        darkTheme: portfolioTheme(Brightness.dark),
        themeMode: _themeMode,
        home: MyHomePage(onToggleTheme: _toggleTheme),
      ),
    );
  }
}
