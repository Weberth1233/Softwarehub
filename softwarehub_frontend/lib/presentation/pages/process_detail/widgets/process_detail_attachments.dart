part of '../process_detail_page.dart';

extension _ProcessDetailPageAttachments on _ProcessDetailPageState {
  Widget _buildAttachmentsList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;

    if (entity.attachments.isEmpty) {
      return this._buildEmptyState(
        context,
        icon: Icons.attach_file_outlined,
        message: "Nenhum anexo vinculado a este processo.",
        // process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.attachments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final attachment = entity.attachments[index];
        final isSigned = attachment.signedFilePath.isNotEmpty;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(AppRoutes.processAttachmentsById(entity.id)),
          child: this._buildSimpleCard(
            context,
            child: Row(
              children: [
                Icon(
                  isSigned ? Icons.check_circle : Icons.description_outlined,
                  color: isSigned ? Colors.green : colors.secondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: colors.tertiary,
                        ),
                      ),
                      Text(
                        attachment.status,
                        style: TextStyle(color: colors.secondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isSigned ? Colors.green : Colors.orange)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isSigned ? "Assinado" : "Pendente",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: isSigned ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
