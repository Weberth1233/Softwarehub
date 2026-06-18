import 'package:flutter/material.dart';

class SearchFieldHighlight extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget field;

  const SearchFieldHighlight({super.key, 
    required this.title,
    required this.icon,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: colors.tertiary),
            const SizedBox(width: 6),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.tertiary.withOpacity(0.85),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        field,
      ],
    );
  }
}
