import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'recent_searches.dart'; // Helper class for SharedPreferences
import 'recent_history_page.dart'; // Page to display recent searches

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Rails Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  String _searchQuery = '';
  // Full result entries as a list of maps.
  List<Map<String, dynamic>> _searchResults = [];
  final RecentSearches recentSearches = RecentSearches();

  Future<void> _performSearch(String query) async {
    setState(() {
      _searchQuery = query;
    });

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      // Send the request with the query parameter "q"
      final response = await http.get(
        Uri.parse('http://localhost:3000/search?q=${Uri.encodeComponent(query)}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assume data['results'] is an array of product objects (maps)
        final List<dynamic> results = data['results'];

        // Save the full search entry (query + full results) into SharedPreferences.
        await recentSearches.addSearchEntry(query, results);

        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(results);
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Future<void> _loadRecentSearches() async {
    final entries = await recentSearches.getRecentSearchEntries();
    // For simplicity, we'll display the results from the most recent entry.
    if (entries.isNotEmpty) {
      setState(() {
        _searchQuery = entries.first["query"] ?? '';
        _searchResults = List<Map<String, dynamic>>.from(entries.first["results"] ?? []);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      SearchPage(
        onSearch: _performSearch,
      ),
      ResultsPage(
        query: _searchQuery,
        results: _searchResults,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TRACE template'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Search Button
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _currentIndex == 0 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              // History Button: Navigates to the RecentHistoryPage.
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecentHistoryPage(),
                    ),
                  );
                },
              ),
              // Results Button
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: _currentIndex == 1 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  final Function(String) onSearch;
  const SearchPage({super.key, required this.onSearch});

  /// This function queries your backend for product suggestions.
  /// The backend endpoint should accept a query parameter "q" and return a JSON with a "suggestions" array,
  /// where each suggestion is a product object (a Map) with keys: "brand", "owner", and "ownership type".
  Future<List<Map<String, dynamic>>> _getSuggestions(String pattern) async {
    if (pattern.isEmpty) return [];
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/suggestions?q=${Uri.encodeComponent(pattern)}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Return the list of product suggestions.
        return List<Map<String, dynamic>>.from(data['suggestions']);
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
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
              onSubmitted: (value) {
                onSearch(value);
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
              // When a suggestion is selected, update the text field and trigger the search.
              controller.text = suggestion['brand'] ?? '';
              onSearch(controller.text);
            },
            noItemsFoundBuilder: (context) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No suggestions found.'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onSearch(controller.text);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

class ResultsPage extends StatelessWidget {
  final String query;
  final List<Map<String, dynamic>> results;
  const ResultsPage({super.key, required this.query, required this.results});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: results.isEmpty
          ? Center(
              child: Text(
                query.isEmpty
                    ? 'No search performed yet.'
                    : 'No results found for "$query".',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ListTile(
                  title: Text(result['brand'] ?? 'No brand'),
                  subtitle: Text(
                    'Owner: ${result['owner'] ?? 'N/A'}\n'
                    'Ownership Type: ${result['ownership type'] ?? result['ownership_type'] ?? 'N/A'}',
                  ),
                );
              },
            ),
    );
  }
}
