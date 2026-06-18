import 'package:flutter/material.dart';

import 'attachment_colors.dart';

class AttachmentActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const AttachmentActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: AttachmentColors.textColor,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: AttachmentColors.textColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: AttachmentColors.textColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}