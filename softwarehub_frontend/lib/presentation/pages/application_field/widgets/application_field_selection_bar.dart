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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [

            // --- PARTE ESQUERDA: Ícone e Contagem ---
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selecionados",
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      selectedCount == 0
                          ? "Nenhum campo selecionado"
                          : "$selectedCount campos selecionados",
                      style: TextStyle(
                        color: colors.primary.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // --- PARTE DIREITA: Botões de Ação ---
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [

                // 1. Botão de Limpar (Resolvido diretamente na View)
                OutlinedButton(
                  onPressed: selectedCount == 0
                      ? null
                      : () {
                    // Como não podemos mexer no Controller, esvaziamos
                    // a lista reativa do GetX diretamente por aqui!
                    controller.selectedFieldIds.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(
                      color: selectedCount == 0
                          ? Colors.grey.shade300
                          : colors.primary.withOpacity(0.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Limpar seleção",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),

                // 2. Botão de Confirmar
                ElevatedButton(
                  onPressed: selectedCount == 0
                      ? null
                      : controller.confirmSelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Confirma seleção",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}