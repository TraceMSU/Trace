import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentSearches {
  static const String _key = 'recent_searches';

  /// Retrieves the list of recent search entries.
  /// Each entry is stored as a JSON object with keys "query" and "results".
  Future<List<Map<String, dynamic>>> getRecentSearchEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs.getStringList(_key) ?? [];
    return entries
        .map((entry) => jsonDecode(entry) as Map<String, dynamic>)
        .toList();
  }

  /// Adds a new search entry to the recent searches list.
  /// [query] is the search term, and [results] is the full result data returned from the backend.
  Future<void> addSearchEntry(String query, List<dynamic> results) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> entries = prefs.getStringList(_key) ?? [];

    // Remove any existing entry with the same query (case-insensitive)
    entries.removeWhere((entry) {
      final Map<String, dynamic> data = jsonDecode(entry);
      return data["query"].toString().toLowerCase() == query.toLowerCase();
    });

    // Encode the search entry as a JSON string.
    final entryJson = jsonEncode({ "query": query, "results": results });
    entries.insert(0, entryJson);

    // Keep only the 10 most recent entries.
    if (entries.length > 10) {
      entries = entries.sublist(0, 10);
    }

    await prefs.setStringList(_key, entries);
  }
}
