import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'results_page.dart';

/// This is the page that allows users to search for products.

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

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
            'http://10.0.2.2:3000/suggestions?q=${Uri.encodeComponent(pattern)}'),
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

  /// Perform the actual search and navigate to ResultsPage.
  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/search?q=${Uri.encodeComponent(query)}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = List<Map<String, dynamic>>.from(data['results']);

        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultsPage(query: query, results: results),
          ),
        );
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch results')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during search')),
      );
    }
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
              onSubmitted: (value) async {
                final suggestions = await _getSuggestions(value);
                if (suggestions.isNotEmpty) {
                  final closest = suggestions.first;
                  controller.text = closest['brand'] ?? '';
                  _handleSearch(controller.text);
                }
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
              _handleSearch(controller.text);
            },
            noItemsFoundBuilder: (context) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No suggestions found.'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _handleSearch(controller.text);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
