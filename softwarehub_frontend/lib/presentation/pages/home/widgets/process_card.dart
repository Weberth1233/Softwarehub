import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/app_routes.dart';

import '../../../../domain/entities/process/process_response_entity.dart';
import '../controllers/home_controller.dart';

class ProcessCard extends StatelessWidget {
  final ProcessResponseEntity item;

  ProcessCard({super.key, required this.item});

  final HomeController processController = Get.find<HomeController>();

  static const double _cardWidth = 440;
  static const double _cardHeight = 250;
  static const double _outerRadius = 10;
  static const double _innerRadius = 5;

  // Cores estruturais do card
  static const Color _orange = Color(0xFFCBD5E1);
  static const Color _titleColor = Color(0xFF0F172A);
  static const Color _subtitleColor = Color(0xFF1E293B);
  static const Color _buttonBlue = Color(0XFF004093);
  static const Color _buttonRed = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final date = item.createdAt.toLocal();
    final dateFormatted =
        "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";

    final int justificationCount = item.justifications.length;
    final bool hasJustifications =
        justificationCount > 0 && item.statusLabel == "Em correção";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _cardWidth,
          height: _cardHeight,
          child: Container(
            padding: const EdgeInsets.all(16), // Espaçamento da borda azul externa
            decoration: BoxDecoration(
              color: Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(_outerRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: PhysicalShape(
              color: Colors.white,
              clipper: const _FolderTabClipper(
                radius: _innerRadius,
              ),
              elevation: 8.0,
              shadowColor: Colors.black.withOpacity(0.7),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.processDetailById(item.id),
                      preventDuplicates: false,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TAG DE IDENTIFICAÇÃO (LARANJA)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.ipType.name.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              // TÍTULO DO PROCESSO
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  height: 1.2,
                                  color: _titleColor,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // ID PROCESS
                              Text(
                                "#${item.id}",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: _subtitleColor,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // DATA DE CRIAÇÃO
                              Text(
                                "Data de criação $dateFormatted",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: _subtitleColor,
                                ),
                              ),

                              const Spacer(),

                              // Tag de Status (Posicionada na base esquerda)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(item.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.statusLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // 👉 COLUNA DA DIREITA: Apenas os botões de ação empilhados
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _actionButton(
                              context: context,
                              icon: Icons.delete_rounded,
                              backgroundColor: _buttonRed,
                              tooltip: "Excluir processo",
                              onTap: () {
                                _showDeleteDialog(context);
                              },
                            ),
                            const SizedBox(height: 8),
                            _actionButton(
                              context: context,
                              icon: Icons.edit_rounded,
                              backgroundColor: _buttonBlue,
                              tooltip: "Editar processo",
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.process,
                                  arguments: {
                                    'isEditMode': true,
                                    'processId': item.id,
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            _actionButton(
                              context: context,
                              icon: Icons.format_list_bulleted_rounded,
                              backgroundColor: _buttonBlue,
                              tooltip: hasJustifications
                                  ? "$justificationCount justificativa(s) vinculada(s) ao processo"
                                  : "Ver detalhes do processo",
                              badgeCount:
                              hasJustifications ? justificationCount : null,
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.processDetailById(item.id),
                                  preventDuplicates: false,
                                  arguments: hasJustifications
                                      ? {'initialSectionIndex': 5}
                                      : null,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required Color backgroundColor,
    required String tooltip,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    final bool hasBadge = badgeCount != null && badgeCount > 0;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 37,
              height: 37,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            if (hasBadge)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    badgeCount > 99 ? "99+" : badgeCount.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Confirmar exclusão",
      middleText:
      "Tem certeza que deseja excluir o processo \"${item.title}\"?",
      textConfirm: "Excluir",
      textCancel: "Cancelar",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        await processController.deleteProcessById(item.id);
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "PENDENTE_DISTRIBUICAO_COTAS":
        return const Color.fromARGB(255, 228, 206, 11);
      case "COTAS_DISTRIBUIDAS":
        return Colors.blue;
      case "CORRECAO":
        return Colors.red;
      case "CORRIGIDO":
        return Colors.orange;
      case "CLASSIFICADO":
        return Colors.purple;
      case "FINALIZADO":
        return const Color.fromARGB(255, 54, 149, 57);
      case "INATIVO":
        return Colors.grey;
      case "PENDENTE_DOCUMENTACAO":
        return Colors.black;
      default:
        return Colors.grey;
    }
  }
}

/// Clipper responsável pelo efeito "Aba de Pasta" do Figma.
class _FolderTabClipper extends CustomClipper<Path> {
  final double radius;

  const _FolderTabClipper({required this.radius});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double tabWidth = size.width * 0.52;
    final double slopeWidth = size.width * 0.08;
    final double tabDrop = 24.0;

    path.moveTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    path.lineTo(tabWidth, 0);
    path.lineTo(tabWidth + slopeWidth, tabDrop);
    path.lineTo(size.width - radius, tabDrop);
    path.arcToPoint(Offset(size.width, tabDrop + radius), radius: Radius.circular(radius));
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius));
    path.lineTo(radius, size.height);
    path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _FolderTabClipper oldClipper) {
    return oldClipper.radius != radius;
  }
}