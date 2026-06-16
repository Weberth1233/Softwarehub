import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/application_field_controller.dart';

class ApplicationFieldSelectionBar extends StatelessWidget {
  final ApplicationFieldController controller;

  const ApplicationFieldSelectionBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
      final selectedCount = controller.selectedFieldIds.length;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.onSecondary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.checklist_outlined, color: colors.primary),
                const SizedBox(width: 12),
                Text(
                  selectedCount == 0
                      ? "Nenhum campo selecionado"
                      : "$selectedCount campo(s) selecionado(s)",
                  style: TextStyle(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            ElevatedButton.icon(
              onPressed: selectedCount == 0
                  ? null
                  : controller.confirmSelection,
              icon: const Icon(Icons.check),
              label: Text(controller.confirmButtonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onSecondary,
                disabledBackgroundColor: colors.secondary.withOpacity(0.25),
                disabledForegroundColor: colors.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
