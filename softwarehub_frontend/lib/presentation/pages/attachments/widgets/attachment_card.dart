import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';

import '../controllers/attachments_controller.dart';
import 'attachment_actions.dart';
import 'attachment_card_header.dart';
import 'attachment_colors.dart';
import 'attachment_upload_info.dart';

class AttachmentCard extends StatelessWidget {
  final AttachmentEntity entity;
  final AttachmentController controller;

  const AttachmentCard({
    super.key,
    required this.entity,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool isSigned = entity.signedFilePath != "";

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 760;

        return Card(
          elevation: 4,
          color: colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(isCompact ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AttachmentCardHeader(
                  entity: entity,
                  isSigned: isSigned,
                  isCompact: isCompact,
                ),
                const SizedBox(height: 20),
                Divider(
                  height: 1,
                  color: AttachmentColors.textColor.withOpacity(0.2),
                ),
                const SizedBox(height: 20),
                isCompact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AttachmentUploadInfo(isSigned: isSigned),
                          const SizedBox(height: 16),
                          AttachmentActions(
                            entity: entity,
                            controller: controller,
                            isSigned: isSigned,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: AttachmentUploadInfo(isSigned: isSigned),
                          ),
                          const SizedBox(width: 16),
                          AttachmentActions(
                            entity: entity,
                            controller: controller,
                            isSigned: isSigned,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}