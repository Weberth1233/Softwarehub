import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/application_field_entity.dart';
import '../controllers/application_field_controller.dart';

class ApplicationFieldTreeItem extends StatelessWidget {
  final ApplicationFieldEntity field;
  final ApplicationFieldController controller;

  const ApplicationFieldTreeItem({
    super.key,
    required this.field,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
      final isSelected = controller.isFieldSelected(field.id);

      return InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => controller.toggleFieldSelection(field.id),
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withOpacity(0.10)
                : colors.primary.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? colors.primary.withOpacity(0.45)
                  : Colors.black.withOpacity(0.06),
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isSelected,
                activeColor: colors.primary,
                onChanged: (_) {
                  controller.toggleFieldSelection(field.id);
                },
              ),

              const SizedBox(width: 8),

              CircleAvatar(
                radius: 18,
                backgroundColor: colors.primary,
                child: Icon(
                  Icons.subdirectory_arrow_right,
                  color: colors.onSecondary,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${field.code} - ${field.name}',
                      style: TextStyle(
                        color: colors.tertiary,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),

                    if (field.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        field.description,
                        style: TextStyle(
                          color: colors.secondary,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FieldChip(
                          icon: Icons.tag,
                          label: field.code,
                        ),
                        _FieldChip(
                          icon: Icons.category_outlined,
                          label: field.applicationAreaCode,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _FieldChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FieldChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: colors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}