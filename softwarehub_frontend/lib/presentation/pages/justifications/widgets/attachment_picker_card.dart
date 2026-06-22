import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/justification_controller.dart';

class AttachmentPickerCard extends GetView<JustificationController> {
  final bool isEditMode;
  final String? currentAttachmentFileName;

  const AttachmentPickerCard({
    super.key,
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

      final bool hasCurrentFile =
          currentAttachmentFileName != null &&
          currentAttachmentFileName!.isNotEmpty;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outline.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.attach_file_rounded, color: colors.primary),
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
                  side: BorderSide(color: colors.primary.withOpacity(0.45)),
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
                  side: BorderSide(color: colors.primary.withOpacity(0.45)),
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
        border: Border.all(color: colors.primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(_getFileIcon(fileName), color: colors.primary),
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
              icon: Icon(Icons.close_rounded, color: colors.error),
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
