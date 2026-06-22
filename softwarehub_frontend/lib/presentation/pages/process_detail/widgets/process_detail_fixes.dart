part of '../process_detail_page.dart';

extension _ProcessDetailPageFixes on _ProcessDetailPageState {
  Widget _buildFixesList(BuildContext context, ProcessResponseEntity entity) {
    final controller = this.controller;

    if (entity.justifications.isEmpty) {
      return this._buildEmptyState(
        context,
        icon: Icons.sticky_note_2_outlined,
        message: "Não há correções ou justificativas.",
        // process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.justifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final justification = entity.justifications[index];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.amber.shade800,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Observação #${justification.id}",
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            justification.reason,
                            style: const TextStyle(
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.isAdmin)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (justification.attachment != null) {
                                await controller.getAttachmentFile(
                                  justification.attachment!.id,
                                );

                                final bytes = controller.attachmentBytes.value;

                                if (bytes == null || bytes.isEmpty) {
                                  AppToast.error(
                                    "Não foi possível carregar o arquivo.",
                                  );
                                  return;
                                }

                                if (controller.isAttachmentImage) {
                                  Get.dialog(
                                    Dialog(
                                      insetPadding: const EdgeInsets.all(24),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 800,
                                          maxHeight: 700,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Image.memory(
                                          bytes,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (controller.isAttachmentPdf) {
                                  controller.openPdfInNewTab();
                                } else {
                                  AppToast.error(
                                    "Tipo de arquivo não suportado para visualização.",
                                  );
                                }
                              } else {
                                AppToast.warning(
                                  "Não há documento disponível para essa justificativa!.",
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.document_scanner,
                              color: Colors.blueGrey,
                              size: 22,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            onPressed: () async {
                              final result = await Get.toNamed(
                                AppRoutes.processJustificationById(entity.id),
                                arguments: {
                                  'processId': entity.id,
                                  'justificationId': justification.id,
                                  'reason': justification.reason,
                                  'attachmentFileName':
                                      justification.attachment?.fileName,
                                },
                              );

                              if (result != null && result is int) {
                                print("Atualizando o processo");
                                await controller.fetchProcess(result);
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 22,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),

                          IconButton(
                            onPressed: _isDeletingJustification
                                ? null
                                : () {
                                    Get.defaultDialog(
                                      title: "Excluir justificativa",
                                      middleText:
                                          "Tem certeza que deseja excluir esta justificativa?",
                                      textConfirm: "Excluir",
                                      textCancel: "Cancelar",
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red,
                                      onConfirm: () async {
                                        Get.back();

                                        await this._runAction(
                                          setLoading: (value) =>
                                              _isDeletingJustification = value,
                                          action: () async {
                                            await controller
                                                .deleteJustificationProcess(
                                                  justification.id,
                                                );
                                          },
                                        );
                                      },
                                    );
                                  },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
