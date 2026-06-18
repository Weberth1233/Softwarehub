import 'package:flutter/material.dart';

class AttachmentsEmptyState extends StatelessWidget {
  const AttachmentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colors.onSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.outline.withOpacity(0.12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 64,
              color: colors.outline,
            ),
            const SizedBox(height: 16),
            Text(
              "Nenhum documento encontrado.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}