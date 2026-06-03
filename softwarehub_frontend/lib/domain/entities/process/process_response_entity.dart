import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_justification_entity.dart';

import '../attachment_entity.dart';
import '../ip_type_entity.dart';
import 'process_user_entity.dart';

class ProcessResponseEntity {
  final int id;
  final String title;
  final String status;
  final bool isFeatured;
  final DateTime createdAt;
  final Map<String, dynamic> formData;
  final IpTypeEntity ipType;
  final List<ProcessUserEntity> authors;
  final List<AttachmentEntity> attachments;
  final List<ProcessJustificationEntity> justifications;
  final List<ExternalAuthorEntity> externalAuthors;
  final ProcessUserEntity creator;


  ProcessResponseEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.isFeatured,
    required this.createdAt,
    required this.formData,
    required this.ipType,
    required this.authors,
    required this.attachments,
    required this.justifications,
    required this.externalAuthors,
    required this.creator,
  });
}
