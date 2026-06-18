
import 'package:flutter/material.dart';

class ResponsiveGrid extends StatelessWidget {
  final int columns;
  final double gap;
  final List<Widget> children;

  const ResponsiveGrid({super.key, 
    required this.columns,
    required this.gap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) SizedBox(height: gap),
          ],
        ],
      );
    }

    final rows = (children.length / columns).ceil();

    return Column(
      children: List.generate(rows, (r) {
        final start = r * columns;
        final end = (start + columns).clamp(0, children.length);
        final rowItems = children.sublist(start, end);

        return Padding(
          padding: EdgeInsets.only(bottom: r == rows - 1 ? 0 : gap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(columns, (c) {
              final idx = start + c;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: c == columns - 1 ? 0 : gap),
                  child: idx < children.length
                      ? rowItems[c]
                      : const SizedBox.shrink(),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
