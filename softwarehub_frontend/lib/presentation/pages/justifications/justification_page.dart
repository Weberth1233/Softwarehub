import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/justifications/controllers/justification_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';

class JustificationPage extends GetView<JustificationController> {
  const JustificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;

    final int idProcess = args['processId'];
    final int? justificationId = args['justificationId'];
    final String? reason = args['reason'];

    final String? attachmentFileName = args['attachmentFileName'];

    final bool isEditMode = justificationId != null;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (isEditMode &&
        reason != null &&
        controller.reasonController.text.isEmpty) {
      controller.reasonController.text = reason;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: colors.primary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          isEditMode ? "Editar Justificativa" : "Justificativa",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: colors.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: colors.onSecondary.withOpacity(0.04),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Responsive.getPadding(context).left,
              20,
              Responsive.getPadding(context).right,
              24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Container(
                  padding: const EdgeInsets.all(24),
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
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Correção / Justificativa",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colors.tertiary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isEditMode
                              ? "Atualize a justificativa do processo #$idProcess."
                              : "Explique o motivo da correção para o processo #$idProcess.",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.secondary,
                          ),
                        ),
                        const SizedBox(height: 18),

                        CustomTextField(
                          controller: controller.reasonController,
                          label: "Justificativa",
                          maxLines: 12,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira uma justificativa.';
                            }
                            if (value.trim().length < 10) {
                              return 'A justificativa deve ter pelo menos 10 caracteres.';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        _AttachmentPickerCard(
                          isEditMode: isEditMode,
                          currentAttachmentFileName: attachmentFileName,
                        ),

                        const SizedBox(height: 18),

                        Obx(() {
                          return SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () {
                                      if (!controller.formKey.currentState!
                                          .validate()) {
                                        return;
                                      }

                                      if (isEditMode) {
                                        controller.put(
                                          justificationId: justificationId,
                                          idProcess: idProcess,
                                        );
                                      } else {
                                        controller.post(idProcess);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.primary,
                                disabledBackgroundColor:
                                    colors.primary.withOpacity(0.55),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      isEditMode ? "Atualizar" : "Enviar",
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: colors.onSecondary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentPickerCard extends GetView<JustificationController> {
  final bool isEditMode;
  final String? currentAttachmentFileName;

  const _AttachmentPickerCard({
    required this.isEditMode,
    this.currentAttachmentFileName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Obx(() {
      final selectedFileName = controller.selectedFileName.value;

      final bool hasNewFile =
          selectedFileName != null && selectedFileName.isNotEmpty;

      final bool hasCurrentFile = currentAttachmentFileName != null &&
          currentAttachmentFileName!.isNotEmpty;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.outline.withOpacity(0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_file_rounded,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Anexo opcional",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.tertiary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              isEditMode
                  ? "Você pode manter o arquivo atual ou selecionar um novo para substituir."
                  : "Você pode anexar uma imagem, PDF ou documento para complementar a justificativa.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.secondary,
              ),
            ),

            const SizedBox(height: 14),

            if (hasNewFile)
              _FileInfoBox(
                fileName: selectedFileName,
                label: "Novo arquivo selecionado",
                onRemove: controller.isLoading.value
                    ? null
                    : controller.removeSelectedFile,
              )
            else if (isEditMode && hasCurrentFile)
              _FileInfoBox(
                fileName: currentAttachmentFileName!,
                label: "Arquivo atual",
                onRemove: null,
              )
            else
              OutlinedButton.icon(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.pickFile,
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text("Selecionar arquivo"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  foregroundColor: colors.primary,
                  side: BorderSide(
                    color: colors.primary.withOpacity(0.45),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

            if (hasNewFile || (isEditMode && hasCurrentFile)) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.pickFile,
                icon: const Icon(Icons.swap_horiz_rounded),
                label: Text(
                  hasNewFile
                      ? "Trocar arquivo selecionado"
                      : "Substituir arquivo atual",
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 46),
                  foregroundColor: colors.primary,
                  side: BorderSide(
                    color: colors.primary.withOpacity(0.45),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _FileInfoBox extends StatelessWidget {
  final String fileName;
  final String label;
  final VoidCallback? onRemove;

  const _FileInfoBox({
    required this.fileName,
    required this.label,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.primary.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(fileName),
            color: colors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              tooltip: "Remover arquivo selecionado",
              onPressed: onRemove,
              icon: Icon(
                Icons.close_rounded,
                color: colors.error,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg')) {
      return Icons.image_rounded;
    }

    if (lower.endsWith('.pdf')) {
      return Icons.picture_as_pdf_rounded;
    }

    if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
      return Icons.description_rounded;
    }

    return Icons.insert_drive_file_rounded;
  }
}

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;

  _DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 80.0;

    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}