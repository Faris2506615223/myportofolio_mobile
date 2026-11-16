import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/theme.dart';

/// Menyimpan pilihan tema pada root agar halaman menu tetap stateless.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

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
    return MaterialApp(
      title: 'MyPortfolio | Faris Salman Azhari',
      debugShowCheckedModeBanner: false,
      theme: portfolioTheme(Brightness.light),
      darkTheme: portfolioTheme(Brightness.dark),
      themeMode: _themeMode,
      home: MyHomePage(onToggleTheme: _toggleTheme),
    );
  }
}
