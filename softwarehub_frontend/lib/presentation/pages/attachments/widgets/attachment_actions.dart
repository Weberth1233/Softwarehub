import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';

import '../controllers/attachments_controller.dart';
import 'attachment_action_button.dart';

class AttachmentActions extends StatelessWidget {
  final AttachmentEntity entity;
  final AttachmentController controller;
  final bool isSigned;

  const AttachmentActions({
    super.key,
    required this.entity,
    required this.controller,
    required this.isSigned,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
      children: [
        AttachmentActionButton(
          icon: Icons.download,
          label: "Baixar Modelo",
          onPressed: () {
            controller.open(entity.id);
          },
        ),
        if (entity.status == "SIGNED")
          AttachmentActionButton(
            icon: Icons.download,
            label: "Baixar Documento assinado",
            onPressed: () {
              controller.open(entity.id, signed: true);
            },
          ),
        AttachmentActionButton(
          icon: isSigned ? Icons.edit : Icons.upload_file,
          label: isSigned ? "Alterar" : "Enviar",
          onPressed: () {
            controller.pickAndUpload(attachmentId: entity.id);
          },
        ),
      ],
    );
  }
}