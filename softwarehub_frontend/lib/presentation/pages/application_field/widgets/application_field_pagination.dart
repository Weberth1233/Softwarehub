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

      // Se houver apenas 1 página (ou nenhuma), ocultamos a paginação
      if (totalPages <= 1) {
        return const SizedBox.shrink();
      }

      // --- LÓGICA DA JANELA DE PAGINAÇÃO ---
      final int startPage = (currentPage - 2).clamp(0, (totalPages - 5).clamp(0, totalPages));
      final int endPage = (startPage + 5).clamp(0, totalPages);

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botão Anterior (Arrow Left)
          _buildNavButton(
            icon: Icons.keyboard_double_arrow_left,
            onPressed: currentPage > 0 ? controller.previousPage : null,
          ),

          const SizedBox(width: 12),

          // Renderização dinâmica dos botões numéricos
          ...List.generate(endPage - startPage, (index) {
            final pageIndex = startPage + index;
            final isActive = pageIndex == currentPage;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildPageButton(
                pageNumber: pageIndex + 1,
                isActive: isActive,
                colors: colors,
                onTap: () {
                  controller.goToPage(pageIndex);
                },
              ),
            );
          }),

          const SizedBox(width: 12),


          _buildNavButton(
            icon: Icons.keyboard_arrow_right,
            onPressed: currentPage < totalPages - 1 ? controller.nextPage : null,
          ),
        ],
      );
    });
  }

  /// Constrói os botões de navegação (Setas)
  Widget _buildNavButton({required IconData icon, required VoidCallback? onPressed}) {
    final bool isDisabled = onPressed == null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDisabled ? Colors.grey.shade300 : const Color(0xFF334155),
        ),
      ),
    );
  }

  /// Constrói os quadrados numéricos
  Widget _buildPageButton({
    required int pageNumber,
    required bool isActive,
    required ColorScheme colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isActive ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? colors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? colors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          pageNumber.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }
}