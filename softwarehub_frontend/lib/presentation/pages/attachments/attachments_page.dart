import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

import 'controllers/attachments_controller.dart';

class AttachmentsPage extends StatefulWidget {
  const AttachmentsPage({super.key});

  @override
  State<AttachmentsPage> createState() => _AttachmentsPageState();
}

class _AttachmentsPageState extends State<AttachmentsPage> {
  final int processId = Get.arguments is int ? Get.arguments : 0;
  final controller = Get.find<AttachmentController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (processId != 0) {
        controller.attachments(processId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text("Documentos do Processo"),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: Responsive.getPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: _buildHeader(
                    context,
                    totalAttachments: controller.attachmentList.length,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.attachmentList.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 720;

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: controller.attachmentList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final entity = controller.attachmentList[index];

                          return _buildAttachmentCard(
                            context,
                            entity,
                            isCompact: isCompact,
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required int totalAttachments,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.onPrimary.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.folder_copy_outlined,
              color: colors.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Anexos necessários",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Baixe os modelos, envie os documentos assinados e acompanhe o status dos arquivos.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimary.withOpacity(0.78),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.onPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: colors.onPrimary.withOpacity(0.18),
              ),
            ),
            child: Text(
              "$totalAttachments ${totalAttachments == 1 ? "item" : "itens"}",
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 520),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colors.onSecondary,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: colors.outline.withOpacity(0.12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_off_outlined,
                size: 38,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Nenhum documento encontrado",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Quando existirem anexos vinculados ao processo, eles aparecerão aqui.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.65),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentCard(
    BuildContext context,
    AttachmentEntity entity, {
    required bool isCompact,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool isSigned =
        entity.signedFilePath.trim().isNotEmpty ||
        entity.status.toUpperCase() == "SIGNED";

    return Container(
      padding: EdgeInsets.all(isCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outline.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDocumentIcon(context, isSigned: isSigned),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAttachmentInfo(
                  context,
                  entity,
                  isCompact: isCompact,
                  isSigned: isSigned,
                ),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 12),
                _buildStatusChip(context, entity.status, isSigned: isSigned),
              ],
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isCompact ? 14 : 16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: colors.outline.withOpacity(0.10),
              ),
            ),
            child: isCompact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUploadStatus(context, isSigned: isSigned),
                      const SizedBox(height: 14),
                      _buildActions(context, entity, isSigned: isSigned),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildUploadStatus(context, isSigned: isSigned),
                      ),
                      const SizedBox(width: 16),
                      _buildActions(context, entity, isSigned: isSigned),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentIcon(
    BuildContext context, {
    required bool isSigned,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: isSigned
            ? const Color(0xFF1B8F4D).withOpacity(0.10)
            : colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        isSigned ? Icons.task_outlined : Icons.description_outlined,
        color: isSigned ? const Color(0xFF1B8F4D) : colors.primary,
        size: 29,
      ),
    );
  }

  Widget _buildAttachmentInfo(
    BuildContext context,
    AttachmentEntity entity, {
    required bool isCompact,
    required bool isSigned,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entity.displayName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.primary,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.insert_drive_file_outlined,
              size: 17,
              color: colors.primary.withOpacity(0.54),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "Modelo: ${entity.templateFilePath}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.primary.withOpacity(0.62),
                ),
              ),
            ),
          ],
        ),
        if (isCompact) ...[
          const SizedBox(height: 12),
          _buildStatusChip(context, entity.status, isSigned: isSigned),
        ],
      ],
    );
  }

  Widget _buildUploadStatus(
    BuildContext context, {
    required bool isSigned,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final statusColor = isSigned
        ? const Color(0xFF1B8F4D)
        : colors.primary.withOpacity(0.72);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Arquivo assinado",
          style: theme.textTheme.bodySmall?.copyWith(
            
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSigned ? Icons.check_circle_outline : Icons.schedule_outlined,
              color: statusColor,
              size: 19,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                isSigned ? "Upload realizado" : "Pendente de envio",
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    AttachmentEntity entity, {
    required bool isSigned,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        _buildOutlinedActionButton(
          context,
          icon: Icons.download_rounded,
          label: "Baixar modelo",
          onPressed: () {
            controller.open(entity.id);
          },
        ),
        if (entity.status.toUpperCase() == "SIGNED")
          _buildOutlinedActionButton(
            context,
            icon: Icons.file_download_done_outlined,
            label: "Baixar assinado",
            onPressed: () {
              controller.open(entity.id, signed: true);
            },
          ),
        _buildPrimaryActionButton(
          context,
          icon: isSigned ? Icons.edit_outlined : Icons.upload_file_outlined,
          label: isSigned ? "Alterar arquivo" : "Enviar arquivo",
          onPressed: () {
            controller.pickAndUpload(attachmentId: entity.id);
          },
        ),
      ],
    );
  }

  Widget _buildOutlinedActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final colors = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(
          color: colors.primary.withOpacity(0.28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildPrimaryActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final colors = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context,
    String status, {
    required bool isSigned,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final normalizedStatus = status.toUpperCase();

    final Color statusColor = isSigned
        ? const Color(0xFF1B8F4D)
        : colors.onSurface.withOpacity(0.65);

    final String label = switch (normalizedStatus) {
      "SIGNED" => "Assinado",
      "PENDING" => "Pendente",
      _ => status.isEmpty ? "Pendente" : status,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: statusColor.withOpacity(0.18),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}