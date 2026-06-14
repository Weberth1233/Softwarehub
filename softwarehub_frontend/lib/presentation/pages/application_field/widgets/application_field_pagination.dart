import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/application_field_controller.dart';

class ApplicationFieldPagination extends StatelessWidget {
  final ApplicationFieldController controller;

  const ApplicationFieldPagination({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Obx(() {
      final currentPage = controller.currentPage.value;
      final totalPages = controller.totalPages.value;

      if (totalPages <= 1) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: colors.onSecondary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: currentPage > 0
                  ? controller.previousPage
                  : null,
              icon: Icon(
                Icons.chevron_left,
                color: currentPage > 0
                    ? colors.primary
                    : colors.secondary.withOpacity(0.4),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Página ${currentPage + 1} de $totalPages',
                style: TextStyle(
                  color: colors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ),

            IconButton(
              onPressed: currentPage < totalPages - 1
                  ? controller.nextPage
                  : null,
              icon: Icon(
                Icons.chevron_right,
                color: currentPage < totalPages - 1
                    ? colors.primary
                    : colors.secondary.withOpacity(0.4),
              ),
            ),
          ],
        ),
      );
    });
  }
}