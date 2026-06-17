import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/application_field_entity.dart';
import '../controllers/application_field_controller.dart';
import 'application_field_tree_item.dart';

class ApplicationFieldAreaTile extends StatelessWidget {
  final String areaName;
  final List<ApplicationFieldEntity> fields;
  final ApplicationFieldController controller;

  const ApplicationFieldAreaTile({
    super.key,
    required this.areaName,
    required this.fields,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final areaCode = fields.isNotEmpty ? fields.first.applicationAreaCode : '';

    return Obx(() {
      final isFullySelected = controller.isAreaFullySelected(fields);
      final isPartiallySelected = controller.isAreaPartiallySelected(fields);
      final isAreaBlocked = controller.isAreaBlocked(fields);

      return Opacity(
        opacity: isAreaBlocked ? 0.45 : 1,
        child: Container(
          decoration: BoxDecoration(
            color: colors.onSecondary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isAreaBlocked
                  ? colors.error.withOpacity(0.35)
                  : Colors.transparent,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Theme(
            data: theme.copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor:
                    isAreaBlocked ? colors.secondary : colors.primary,
                child: Text(
                  areaCode.isNotEmpty ? areaCode.substring(0, 1) : '?',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              title: Text(
                areaName,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: colors.tertiary,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${fields.length} campo(s) encontrado(s)',
                    style: TextStyle(
                      color: colors.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isAreaBlocked) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Desmarque o bloco atual para selecionar este.',
                      style: TextStyle(
                        color: colors.error,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: Checkbox(
                tristate: true,
                value: isFullySelected
                    ? true
                    : isPartiallySelected
                        ? null
                        : false,
                activeColor: colors.primary,
                onChanged: isAreaBlocked
                    ? null
                    : (_) {
                        controller.toggleAreaSelection(fields);
                      },
              ),
              children: fields.map((field) {
                final isFieldBlocked = controller.isFieldBlocked(field);

                return Opacity(
                  opacity: isFieldBlocked ? 0.45 : 1,
                  child: AbsorbPointer(
                    absorbing: isFieldBlocked,
                    child: ApplicationFieldTreeItem(
                      field: field,
                      controller: controller,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}