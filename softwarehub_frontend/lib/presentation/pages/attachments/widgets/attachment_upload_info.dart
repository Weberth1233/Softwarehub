import 'package:flutter/material.dart';

import 'attachment_colors.dart';

class AttachmentUploadInfo extends StatelessWidget {
  final bool isSigned;

  const AttachmentUploadInfo({
    super.key,
    required this.isSigned,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryTextColor = AttachmentColors.textColor.withOpacity(0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Arquivo Assinado fff:",
          style: theme.textTheme.bodySmall?.copyWith(
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                isSigned ? "Upload realizado" : "Pendente de envio",
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSigned
                      ? AttachmentColors.statusColor
                      : AttachmentColors.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isSigned) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle,
                color: AttachmentColors.statusColor,
                size: 18,
              ),
            ],
          ],
        ),
      ],
    );
  }
}