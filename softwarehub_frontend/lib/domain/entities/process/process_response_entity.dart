import '../attachment_entity.dart';
import '../external_author/external_author_entity.dart';
import '../ip_type_entity.dart';
import '../nice_classification_entity.dart';
import 'process_justification_entity.dart';
import 'process_royalty_distribution_response_entity.dart';
import 'process_user_entity.dart';

class ProcessResponseEntity {
  final int id;
  final String title;
  final String status;
  final String statusLabel;
  final DateTime createdAt;
  final Map<String, dynamic> formData;
  final IpTypeEntity ipType;
  final List<ProcessUserEntity> authors;
  final List<AttachmentEntity> attachments;
  final List<ProcessJustificationEntity> justifications;
  final List<ExternalAuthorEntity> externalAuthors;
  final ProcessUserEntity creator;
  final NiceClassificationEntity niceClassificationModel;
  final List<ProcessRoyaltyDistributionResponseEntity> royaltyDistributions;

  ProcessResponseEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
    required this.formData,
    required this.ipType,
    required this.authors,
    required this.attachments,
    required this.justifications,
    required this.externalAuthors,
    required this.creator,
    required this.niceClassificationModel,
    required this.royaltyDistributions,
  });

}
