// lib/results_page.dart
import 'package:flutter/material.dart';
import 'heap_result_tile.dart';

/// Displays the search results without its own Scaffold.
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
                    : 'No results found for "\$query".',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: HeapResultTile(
                    ownershipType: result['ownership type'] ??
                        result['ownership_type'] ??
                        'N/A',
                    owner: result['owner'] ?? 'N/A',
                    brand: result['brand'] ?? 'No brand',
                  ),
                );
              },
            ),
    );
  }
}