import 'package:flutter/material.dart';
import 'recent_history_page.dart'; // Page to display recent searches
import 'search_page.dart'; // Your new search page with built-in navigation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryColor = Color(0xFF5A10B2);
  static const Color primaryHoverColor = Color(0xFF470E8F);
  static const Color primaryPressedColor = Color(0xFF390B74);
  static const Color primaryDisabledColor = Color(0xFFC3AEE3);
  static const Color secondaryColor = Color(0xFFEDE4FB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Rails Template',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: secondaryColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) return primaryDisabledColor;
              if (states.contains(WidgetState.pressed)) return primaryPressedColor;
              if (states.contains(WidgetState.hovered)) return primaryHoverColor;
              return primaryColor;
            }),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: const BorderSide(color: primaryColor),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRACE template'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Search History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecentHistoryPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: const SearchPage(),
    );
  }
}
