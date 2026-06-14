import 'package:flutter/material.dart';

class ApplicationFieldHeaderCard extends StatelessWidget {
  final int totalAreas;
  final int totalFields;
  final bool isDesktop;

  const ApplicationFieldHeaderCard({
    super.key,
    required this.totalAreas,
    required this.totalFields,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 25 : 16,
        vertical: isDesktop ? 25 : 16,
      ),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Árvore de Campos de Aplicação",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: isDesktop ? 25 : 18,
                    fontWeight: FontWeight.w900,
                    color: colors.tertiary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$totalAreas área(s) • $totalFields campo(s)",
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 15 : 10,
              vertical: isDesktop ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  size: 16,
                  color: colors.primary,
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 6),
                  Text(
                    "Seleção",
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}