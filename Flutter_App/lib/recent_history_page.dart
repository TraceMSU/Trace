import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // in case you need it here
import 'recent_searches.dart';

class RecentHistoryPage extends StatefulWidget {
  const RecentHistoryPage({super.key});

  @override
  State<RecentHistoryPage> createState() => _RecentHistoryPageState();
}

class _RecentHistoryPageState extends State<RecentHistoryPage> {
  final RecentSearches _recentSearches = RecentSearches();
  // We'll store each entry as a Map containing "query" and "results".
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
    await prefs.remove('recent_searches');
    _loadRecentEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Searches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearEntries,
          ),
        ],
      ),
      body: _entries.isEmpty
          ? const Center(child: Text('No recent searches.'))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final query = entry['query'] ?? 'Unknown query';
                final List<dynamic> results = entry['results'] ?? [];
                return ExpansionTile(
                  title: Text('$query (${results.length} result${results.length == 1 ? '' : 's'})'),
                  children: results.map<Widget>((result) {
                    // Each result should be a Map with keys like 'brand', 'owner', and 'ownership type'
                    return ListTile(
                      title: Text(result['brand'] ?? 'No brand'),
                      subtitle: Text(
                        'Owner: ${result['owner'] ?? 'N/A'}\n'
                        'Ownership Type: ${result['ownership type'] ?? result['ownership_type'] ?? 'N/A'}',
                      ),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
