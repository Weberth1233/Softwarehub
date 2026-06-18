import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';

import 'attachment_colors.dart';
import 'attachment_status_chip.dart';

class AttachmentCardHeader extends StatelessWidget {
  final AttachmentEntity entity;
  final bool isSigned;
  final bool isCompact;

  const AttachmentCardHeader({
    super.key,
    required this.entity,
    required this.isSigned,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryTextColor = AttachmentColors.textColor.withOpacity(0.7);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AttachmentColors.iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.description,
            color: AttachmentColors.textColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AttachmentColors.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Modelo: ${entity.templateFilePath}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
              if (isCompact && isSigned) ...[
                const SizedBox(height: 12),
                AttachmentStatusChip(label: entity.status),
              ],
            ],
          ),
        ),
        if (!isCompact && isSigned) ...[
          const SizedBox(width: 12),
          AttachmentStatusChip(label: entity.status),
        ],
      ],
    );
  }
}