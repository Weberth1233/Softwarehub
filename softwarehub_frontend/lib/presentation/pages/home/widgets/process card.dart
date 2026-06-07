import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../controllers/home_controller.dart';

class ProcessCard extends StatelessWidget {
  final ProcessResponseEntity item;

  ProcessCard({super.key, required this.item});

  final ProcessController processController = Get.find<ProcessController>();

  @override
  Widget build(BuildContext context) {
    const contentColor = Colors.white;

    String color = "0XFF${item.ipType.color}";

    final date = item.createdAt.toLocal();
    final dateFormatted =
        "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";

    
    String textCorrect(){
      
      return item.statusLabel;

    }

    return SizedBox(
      width: 400,
      height: 190,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Get.toNamed('/home/process-detail/${item.id}',
                preventDuplicates: false);
          },
          child: Stack(
            children: [
              /// BACKGROUND GRADIENT
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0XFF004093),
                      Color(0XFF0A5BD8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              /// WATERMARK ICON
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  Icons.folder_copy_rounded,
                  size: 120,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),

              /// DELETE BUTTON
              Positioned(
                top: 10,
                right: 10,
                child: _actionButton(
                  icon: Icons.delete_outline,
                  color: Colors.red,
                  tooltip: "Excluir processo",
                  onTap: () {
                    _showDeleteDialog(context);
                  },
                ),
              ),

              /// EDIT BUTTON
              Positioned(
                top: 10,
                right: 50,
                child: _actionButton(
                  icon: Icons.edit_outlined,
                  color: Colors.blue,
                  tooltip: "Editar processo",
                  onTap: () {
                    Get.toNamed("/process-edit", arguments: item);
                  },
                ),
              ),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TYPE BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Color(int.parse(color)).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.ipType.name.toUpperCase(),
                        style: TextStyle(
                          color: Color(int.parse(color)),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// TITLE
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: contentColor,
                        fontSize: 20,
                        height: 1.3,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const Spacer(),

                    Divider(
                      color: Colors.white.withOpacity(0.15),
                    ),

                    const SizedBox(height: 6),

                    /// STATUS + DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// STATUS
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
                            textCorrect(),
                            style: context.textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),

                        /// DATE
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateFormatted,
                              style: context.textTheme.bodySmall!.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
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

  /// ACTION BUTTON (EDIT / DELETE)
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  /// DELETE DIALOG
  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Confirmar exclusão",
      middleText: "Tem certeza que deseja excluir o processo \"${item.title}\"?",
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

  /// STATUS COLOR
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "aprovado":
        return Colors.green.withOpacity(0.25);
      case "pendente":
        return Colors.orange.withOpacity(0.25);
      case "rejeitado":
        return Colors.red.withOpacity(0.25);
      default:
        return Colors.white.withOpacity(0.15);
    }
  }
}