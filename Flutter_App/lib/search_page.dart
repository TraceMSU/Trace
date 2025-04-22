// lib/search_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

const String apiBase = 'https://tracetest-dc00a8c7f59d.herokuapp.com';

/// This page allows users to search for products.
/// It uses a callback to pass results back to the MainScreen.
class SearchPage extends StatefulWidget {
  final void Function(String, List<Map<String, dynamic>>) onSearch;
  const SearchPage({super.key, required this.onSearch});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

Future<List<Map<String, dynamic>>> _getSuggestions(String pattern) async {
  if (pattern.isEmpty) return [];
  try {
    final response = await http.get(
      Uri.parse('$apiBase/suggestions?q=${Uri.encodeComponent(pattern)}'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('💡 Suggestions response: $data');
      return List<Map<String, dynamic>>.from(data['suggestions']);
    } else {
      debugPrint('❌ Suggestions error: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('⚠️ Suggestions exception: $e');
  }
  return [];
}

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;
    try {
      final response = await http.get(
        Uri.parse('$apiBase/search?q=${Uri.encodeComponent(query)}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = List<Map<String, dynamic>>.from(data['results']);
        widget.onSearch(query, results);
      } else {
        // handle error if needed
      }
    } catch (_) {
      // handle exception if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TypeAheadField<Map<String, dynamic>>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter search term',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _performSearch(value),
            ),
            suggestionsCallback: _getSuggestions,
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion['brand'] ?? ''),
                subtitle: Text(
                  'Owner: ${suggestion['owner'] ?? 'N/A'}\n'
                  'Ownership Type: ${suggestion['ownership type'] ?? suggestion['ownership_type'] ?? 'N/A'}',
                ),
              );
            },
            onSuggestionSelected: (suggestion) {
              controller.text = suggestion['brand'] ?? '';
              _performSearch(controller.text);
            },
            noItemsFoundBuilder: (_) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No suggestions found.'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _performSearch(controller.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}