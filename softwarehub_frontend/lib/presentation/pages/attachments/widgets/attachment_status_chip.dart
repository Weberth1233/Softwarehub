import 'package:flutter/material.dart';

import 'attachment_colors.dart';

class AttachmentStatusChip extends StatelessWidget {
  final String label;

  const AttachmentStatusChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AttachmentColors.statusColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AttachmentColors.textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}