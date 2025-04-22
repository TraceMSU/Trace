// lib/main.dart
import 'package:flutter/material.dart';
import 'search_page.dart';
import 'results_page.dart';
import 'recent_history_page.dart';
import 'recent_searches.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T.R.A.C.E.',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A10B2),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _query = '';
  List<Map<String, dynamic>> _results = [];

void _onSearch(String query, List<Map<String, dynamic>> results) async {
  setState(() {
    _query = query;
    _results = results;
    _currentIndex = 1; // Show results tab
  });

  // Save to recent history
  await RecentSearches().addSearchEntry(query, results);
}


  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      SearchPage(onSearch: _onSearch),
      ResultsPage(query: _query, results: _results),
      const RecentHistoryPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('T.R.A.C.E.')),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Results',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}