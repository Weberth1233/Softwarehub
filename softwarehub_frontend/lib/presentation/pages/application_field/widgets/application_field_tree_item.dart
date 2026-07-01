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
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.toggleFieldSelection(field),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withOpacity(0.04)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? colors.primary.withOpacity(0.5)
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- LINHA 1: Checkbox + Código e Nome ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Falso Checkbox Customizado
                  Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 2), // Leve ajuste para alinhar com o texto
                    decoration: BoxDecoration(
                      color: isSelected ? colors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? colors.primary : Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Título Completo
                  Expanded(
                    child: Text(
                      '${field.code} - ${field.name}',
                      style: TextStyle(
                        color: isSelected ? colors.primary : const Color(0xFF1E293B),
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // --- LINHA 2: Descrição (Se existir) ---
              if (field.description.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 34), // 22 (checkbox) + 12 (espaço)
                  child: Text(
                    field.description,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // --- LINHA 3: Tags / Chips ---
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 34), // Mantém o alinhamento
                child: Wrap(
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
              ),
            ],
          ),
        ),
      );
    });
  }
}

// Sub-componente para manter o código limpo
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
        color: colors.primary.withOpacity(0.08), // Fundo azul bem suave
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.primary.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: colors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}