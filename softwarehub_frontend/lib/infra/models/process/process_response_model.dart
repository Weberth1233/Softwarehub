import 'package:nit_sgpi_frontend/infra/models/base_model.dart';
import 'package:nit_sgpi_frontend/infra/models/external_author_model.dart';
import 'package:nit_sgpi_frontend/infra/models/ip_types/ip_types_model.dart';
import 'package:nit_sgpi_frontend/infra/models/nice_classification_model.dart';
import 'package:nit_sgpi_frontend/infra/models/process/process_justification_model.dart';

import '../../../domain/entities/process/process_response_entity.dart';
import '../attachment_model.dart';
import 'process_royalty_distribution_response_model.dart';
import 'process_user_model.dart';

class ProcessResponseModel implements BaseModel {
  @override
  final int id;
  final String title;
  final String status;
  final String statusLabel;

  final DateTime createdAt;
  final Map<String, dynamic> formData;
  final IpTypeModel ipType;
  final List<ProcessUserModel> authors;
  final List<AttachmentModel> attachments;
  final List<ProcessJustificationModel> justifications;
  final List<ExternalAuthorModel> externalAuthors;
  final ProcessUserModel creator;
  final NiceClassificationModel niceClassificationModel;
  final List<ProcessRoyaltyDistributionResponseModel> royaltyDistributions;

  ProcessResponseModel({
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

  factory ProcessResponseModel.fromJson(Map<String, dynamic> json) {
    return ProcessResponseModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      statusLabel: json['statusLabel'],
      createdAt: DateTime.parse(json['createdAt']),
      formData: Map<String, dynamic>.from(json['formData'] ?? {}),
      ipType: IpTypeModel.fromJson(json['ipType']),
      niceClassificationModel: json['niceClassification'] == null
          ? NiceClassificationModel.empty()
          : NiceClassificationModel.fromJson(
              Map<String, dynamic>.from(json['niceClassification']),
            ),
      authors: (json['authors'] as List? ?? [])
          .map((e) => ProcessUserModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      attachments: (json['attachments'] as List? ?? [])
          .map((e) => AttachmentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      justifications: (json['justifications'] as List? ?? [])
          .map(
            (e) => ProcessJustificationModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
      creator: ProcessUserModel.fromJson(json['creator']),
      externalAuthors: (json['externalAuthors'] as List? ?? [])
          .map(
            (e) => ExternalAuthorModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
      royaltyDistributions: (json['royaltyDistributions'] as List? ?? [])
          .map(
            (e) => ProcessRoyaltyDistributionResponseModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  @override
  ProcessResponseEntity toEntity() {
    return ProcessResponseEntity(
      id: id,
      title: title,
      status: status,
      statusLabel: statusLabel,
      createdAt: createdAt,
      formData: formData,
      ipType: ipType.toEntity(),
      niceClassificationModel: niceClassificationModel.toEntity(),
      authors: authors.map((e) => e.toEntity()).toList(),
      attachments: attachments.map((e) => e.toEntity()).toList(),
      creator: creator.toEntity(),
      justifications: justifications.map((e) => e.toEntity()).toList(),
      externalAuthors: externalAuthors.map((e) => e.toEntity()).toList(),
      royaltyDistributions: royaltyDistributions
          .map((e) => e.toEntity())
          .toList(),
    );
  }
}
