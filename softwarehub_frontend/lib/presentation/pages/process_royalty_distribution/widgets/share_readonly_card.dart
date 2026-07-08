import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'percentage_field.dart';
import 'share_form_model.dart';

class ShareReadonlyCard extends StatelessWidget {
  const ShareReadonlyCard({
    super.key,
    required this.index,
    required this.share,
    required this.onSliderChanged,
    required this.onTextChanged,
    required this.onRequestUniversityChange,
  });

  final int index;
  final ShareFormModel share;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onTextChanged;
  final VoidCallback onRequestUniversityChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isUniversity = share.type == ShareType.university;
      final isCreator = share.type == ShareType.creator;
      final typeColor = _getTypeColor(share.type, colorScheme);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colorScheme.onSurface.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: typeColor.withOpacity(0.12),
                  child: Icon(
                    _getTypeIcon(share.type),
                    size: 18,
                    color: typeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        share.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    share.type.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PercentageField(
              value: share.percentage.value,
              controller: share.percentageController,
              enabled: !share.isLocked,
              minPercentage: share.minPercentage,
              helperText: isCreator ? "Mínimo obrigatório: 5%" : null,
              onSliderChanged: onSliderChanged,
              onTextChanged: onTextChanged,
            ),
            if (isUniversity) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A cota da universidade é fixa em 70%.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: onRequestUniversityChange,
                        icon: Icon(
                          Icons.edit_note_outlined,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          "Solicitar alteração",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  String _subtitle() {
    switch (share.type) {
      case ShareType.university:
        return "Instituição de ensino";
      case ShareType.creator:
        return "Criador do processo";
      case ShareType.member:
        return "Autor/Membro participante";
      case ShareType.memberExternal:
        return "Membro externo participante";
    }
  }

  IconData _getTypeIcon(ShareType type) {
    switch (type) {
      case ShareType.university:
        return Icons.school_outlined;
      case ShareType.creator:
        return Icons.person_pin_outlined;
      case ShareType.member:
        return Icons.person_outline;
      case ShareType.memberExternal:
        return Icons.person_add_alt_1_outlined;
    }
  }

  Color _getTypeColor(ShareType type, ColorScheme scheme) {
    switch (type) {
      case ShareType.university:
        return scheme.primary;
      case ShareType.creator:
        return scheme.secondary;
      case ShareType.member:
        return scheme.tertiary;
      case ShareType.memberExternal:
        return Colors.deepOrange;
    }
  }
}