// lib/recent_history_page.dart
import 'package:flutter/material.dart';
import 'recent_searches.dart';

/// Now accepts an onSelect callback.
class RecentHistoryPage extends StatefulWidget {
  final void Function(String query, List<Map<String, dynamic>> results) onSelect;
  const RecentHistoryPage({
    super.key,
    required this.onSelect,
  });

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
    await _recentSearches.clear(); // add clear() in RecentSearches for tidiness
    _loadRecentEntries();
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) {
      return const Center(child: Text('No recent searches.'));
    }
    return ListView.builder(
      itemCount: _entries.length,
      itemBuilder: (context, index) {
        final entry = _entries[index];
        final query = entry['query'] as String;
        final results = List<Map<String, dynamic>>.from(entry['results'] ?? []);

        return ListTile(
          title: Text('$query (${results.length} result${results.length == 1 ? '' : 's'})'),
          onTap: () {
            // fire the callback, MainScreen will switch to Results
            widget.onSelect(query, results);
          },
        );
      },
    );
  }
}
