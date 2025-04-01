import 'package:flutter/material.dart';

/// this widget formats the search results.

class HeapResultTile extends StatelessWidget {
  final String ownershipType;
  final String owner;
  final String brand;

  const HeapResultTile({
    Key? key,
    required this.ownershipType,
    required this.owner,
    required this.brand,
  }) : super(key: key);

  // Fixed width for node alignment.
  static const double nodeContainerWidth = 24;

  // Builds a small rectangular node with a double-rectangle effect.
  Widget buildNode() {
    const double outerWidth = 16;
    const double outerHeight = 20;
    const double innerWidth = 10;
    const double innerHeight = 14;
    const double borderWidth = 1.5;

    return Container(
      width: outerWidth,
      height: outerHeight,
      color: Colors.black,
      child: Center(
        child: Container(
          width: innerWidth,
          height: innerHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: borderWidth),
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Builds a row with a node and its corresponding data.
  // The text is conditionally centered or left-aligned.
  Widget buildRow(String text) {
    final TextAlign alignment =
        text.length > 15 ? TextAlign.left : TextAlign.center;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: nodeContainerWidth,
          alignment: Alignment.center,
          child: buildNode(),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: alignment,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  // Helper widget for the arrow row (upward arrow) aligned with the node.
  Widget arrowRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: nodeContainerWidth,
          child: const Center(
            child: Icon(
              Icons.arrow_upward,
              size: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMegacorp = ownershipType.toLowerCase() == 'megacorp';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top banner expands to the full screen width.
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          color: isMegacorp ? Colors.red : Colors.green,
          child: Text(
            ownershipType,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Center the heap structure.
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildRow(ownershipType),
              arrowRow(),
              const SizedBox(height: 4),
              buildRow(owner),
              arrowRow(),
              const SizedBox(height: 4),
              buildRow(brand),
            ],
          ),
        ),
      ],
    );
  }
}
