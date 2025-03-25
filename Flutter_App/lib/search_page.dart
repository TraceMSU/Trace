import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

/// This is the page that allows users to search for products.

class SearchPage extends StatefulWidget {
  final Function(String) onSearch;
  const SearchPage({super.key, required this.onSearch});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  /// Queries your backend for product suggestions.
  Future<List<Map<String, dynamic>>> _getSuggestions(String pattern) async {
    if (pattern.isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/suggestions?q=${Uri.encodeComponent(pattern)}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['suggestions']);
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Use TypeAheadField to show product suggestions.
          TypeAheadField<Map<String, dynamic>>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter search term',
                border: OutlineInputBorder(),
              ),
              // Modified onSubmitted: only trigger search if exactly one suggestion exists.
              onSubmitted: (value) async {
                final suggestions = await _getSuggestions(value);
                if (suggestions.length == 1) {
                  final closest = suggestions.first;
                  controller.text = closest['brand'] ?? '';
                  widget.onSearch(controller.text);
                }
                // Otherwise, do nothing so that the dropdown remains open.
              },
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
              widget.onSearch(controller.text);
            },
            noItemsFoundBuilder: (context) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No suggestions found.'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onSearch(controller.text);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
