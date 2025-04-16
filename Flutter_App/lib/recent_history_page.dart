// lib/recent_history_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recent_searches.dart';

/// Displays recent search entries without its own Scaffold.
class RecentHistoryPage extends StatefulWidget {
  const RecentHistoryPage({super.key});

  @override
  State<RecentHistoryPage> createState() => _RecentHistoryPageState();
}

class _RecentHistoryPageState extends State<RecentHistoryPage> {
  final RecentSearches _recentSearches = RecentSearches();
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadRecentEntries();
  }

  Future<void> _loadRecentEntries() async {
    final entries = await _recentSearches.getRecentSearchEntries();
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _clearEntries() async {
    final prefs = await SharedPreferences.getInstance();
    // previously: prefs.remove(RecentSearches._key);
    await prefs.remove('recent_searches');
    _loadRecentEntries();
  }

  @override
  Widget build(BuildContext context) {
    return _entries.isEmpty
        ? const Center(child: Text('No recent searches.'))
        : ListView.builder(
            itemCount: _entries.length,
            itemBuilder: (context, index) {
              final entry = _entries[index];
              final query = entry['query'] ?? 'Unknown query';
              final results =
                  List<Map<String, dynamic>>.from(entry['results'] ?? []);
              return ListTile(
                title: Text(
                  '$query (${results.length} result${results.length == 1 ? '' : 's'})',
                ),
                onTap: () {
                  // implement callback or navigation as needed
                },
              );
            },
          );
  }
}
