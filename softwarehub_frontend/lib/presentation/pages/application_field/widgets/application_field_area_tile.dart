import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/application_field_entity.dart';
import '../controllers/application_field_controller.dart';
import 'application_field_tree_item.dart';

class ApplicationFieldAreaTile extends StatefulWidget {
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
  State<ApplicationFieldAreaTile> createState() =>
      _ApplicationFieldAreaTileState();
}

class _ApplicationFieldAreaTileState extends State<ApplicationFieldAreaTile> {
  // Variável para controlar dinamicamente a rotação do botão de expandir
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200, // Borda sutil como no Figma
          width: 1,
        ),
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent, // Remove a linha feia padrão do ExpansionTile
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          // 1. Novo Ícone de Pasta (Leading)
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.folder_outlined,
              color: colors.primary,
              size: 24,
            ),
          ),
          title: Text(
            widget.areaName,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B), // Cinza escuro elegante
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '${widget.fields.length} campos cadastrados',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // 2. Trailing Customizado: Checkbox + Badge + Botão de Expandir
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mantemos o Checkbox aqui para preservar a lógica de selecionar toda a área
              Obx(() {
                final isFullySelected =
                widget.controller.isAreaFullySelected(widget.fields);
                final isPartiallySelected =
                widget.controller.isAreaPartiallySelected(widget.fields);

                return Checkbox(
                  tristate: true,
                  value: isFullySelected
                      ? true
                      : isPartiallySelected
                      ? null
                      : false,
                  activeColor: colors.primary,
                  onChanged: (_) {
                    widget.controller.toggleAreaSelection(widget.fields);
                  },
                );
              }),
              const SizedBox(width: 8),

              // Badge "15 campos"
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${widget.fields.length} campos',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Botão de expandir animado
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0.0, // Gira 180 graus (0.5 de uma volta)
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          // 3. Distribuição dos filhos em formato de Grade (Wrap + LayoutBuilder)
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 600;

                final double itemWidth = isDesktop
                    ? (constraints.maxWidth - 24) / 3
                    : constraints.maxWidth;

                // 👇 A CORREÇÃO ENTRA AQUI: SizedBox forçando a largura e WrapAlignment.start
                return SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.fields.map((field) {
                      return SizedBox(
                        width: itemWidth,
                        child: ApplicationFieldTreeItem(
                          field: field,
                          controller: widget.controller,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}