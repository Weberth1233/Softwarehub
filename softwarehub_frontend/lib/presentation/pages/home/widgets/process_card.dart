import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/app_routes.dart';

import '../../../../domain/entities/process/process_response_entity.dart';
import '../controllers/home_controller.dart';

class ProcessCard extends StatelessWidget {
  final ProcessResponseEntity item;

  ProcessCard({super.key, required this.item});

  final ProcessController processController = Get.find<ProcessController>();

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

    String getFirstTwoNames(String? fullName) {
      if (fullName == null || fullName.trim().isEmpty) {
        return "Usuário";
      }

      final names = fullName.trim().split(RegExp(r'\s+'));

      if (names.length >= 2) {
        return "${names[0]} ${names[1]}";
      }

      return names.first;
    }

    return SizedBox(
      width: 400,
      height: 220,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: InkWell(
          onTap: () {
            Get.toNamed(
              AppRoutes.processDetailById(item.id),
              preventDuplicates: false,
            );
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: colorTheme.onSecondary),
              ),

              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  Icons.folder_copy_rounded,
                  size: 120,
                  color: colorTheme.onSurface.withValues(alpha: 0.3),
                ),
              ),

              Positioned(
                bottom: 20,
                right: 10,
                child: _actionButton(
                  context: context,
                  icon: Icons.delete_outline,
                  color: colorTheme.onSurface,
                  tooltip: "Excluir processo",
                  onTap: () {
                    _showDeleteDialog(context);
                  },
                ),
              ),

              /// EDIT BUTTON
              Positioned(
                bottom: 20,
                right: 50,
                child: _actionButton(
                  context: context,
                  icon: Icons.edit_outlined,
                  color: colorTheme.onSurface,
                  tooltip: "Editar processo",
                  onTap: () {
                    Get.toNamed(AppRoutes.process, arguments: item);
                  },
                ),
              ),

              if (hasJustifications)
                Positioned(
                  bottom: 20,
                  right: 90,
                  child: _actionButton(
                    context: context,
                    icon: Icons.notifications_active_outlined,
                    color: Colors.orange,
                    tooltip:
                        "$justificationCount justificativa(s) vinculada(s) ao processo",
                    badgeCount: justificationCount,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.processDetailById(item.id),
                        preventDuplicates: false,
                        arguments: {'initialSectionIndex': 5},
                      );
                    },
                  ),
                ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: colorTheme.onSurface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 18,
                            spreadRadius: 1,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        item.ipType.name.toUpperCase(),
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    Row(
                      spacing: 20,
                      children: [
                        Text(
                          "#${item.id.toString()}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          getFirstTwoNames(item.creator.fullName),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: colorTheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateFormatted,
                              style: textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Divider(color: Colors.white.withOpacity(0.15)),

                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(item.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.statusLabel,
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    final bool hasBadge = badgeCount != null && badgeCount > 0;
    final colorTheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colorTheme.tertiary, size: 20),
            ),

            if (hasBadge)
              Positioned(
                top: -7,
                right: -7,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
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
    switch (status.toUpperCase()) {
      case "FINALIZADO":
      case "APROVADO":
        return Colors.green;

      case "EM_ANDAMENTO":
      case "PENDENTE":
        return Colors.orange;

      case "CORRECAO":
      case "REJEITADO":
        return Colors.red;

      default:
        return Colors.white;
    }
  }
}
