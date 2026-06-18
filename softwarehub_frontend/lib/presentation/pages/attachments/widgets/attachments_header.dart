import 'package:flutter/material.dart';

class AttachmentsHeader extends StatelessWidget {
  final int totalAttachments;

  const AttachmentsHeader({
    super.key,
    required this.totalAttachments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.folder_copy_outlined,
              color: colors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Anexos Necessários",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$totalAttachments ${totalAttachments == 1 ? "documento encontrado" : "documentos encontrados"}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}