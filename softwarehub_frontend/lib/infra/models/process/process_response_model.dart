import 'package:nit_sgpi_frontend/infra/models/base_model.dart';
import 'package:nit_sgpi_frontend/infra/models/external_author_model.dart';
import 'package:nit_sgpi_frontend/infra/models/ip_types/ip_types_model.dart';
import 'package:nit_sgpi_frontend/infra/models/justification/justification_response_model.dart';

import '../../../domain/entities/process/process_response_entity.dart';
import '../application_field_model.dart';
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
  final List<JustificationResponseModel> justifications;
  final List<ExternalAuthorModel> externalAuthors;
  final ProcessUserModel creator;
  final List<ProcessRoyaltyDistributionResponseModel> royaltyDistributions;
  final List<ApplicationFieldModel> applicationFields;

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
    required this.royaltyDistributions,
    required this.applicationFields,
  });

  factory ProcessResponseModel.fromJson(Map<String, dynamic> json) {
    return ProcessResponseModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      statusLabel: json['statusLabel'],
      createdAt: DateTime.parse(json['createdAt']),
      formData: Map<String, dynamic>.from(json['formData'] ?? {}),

      ipType: IpTypeModel.fromJson(
        Map<String, dynamic>.from(json['ipType']),
      ),

      authors: (json['authors'] as List? ?? [])
          .map(
            (e) => ProcessUserModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),

      attachments: (json['attachments'] as List? ?? [])
          .map(
            (e) => AttachmentModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),

      justifications: (json['justifications'] as List? ?? [])
          .map(
            (e) => JustificationResponseModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),

      creator: ProcessUserModel.fromJson(
        Map<String, dynamic>.from(json['creator']),
      ),

      externalAuthors: (json['externalAuthors'] as List? ?? [])
          .map(
            (e) => ExternalAuthorModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),

      royaltyDistributions: (json['royaltyDistributions'] as List? ?? [])
          .map(
            (e) => ProcessRoyaltyDistributionResponseModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),

      applicationFields: (json['applicationFields'] as List? ?? [])
          .map(
            (e) => ApplicationFieldModel.fromJson(
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
      authors: authors.map((e) => e.toEntity()).toList(),
      attachments: attachments.map((e) => e.toEntity()).toList(),
      creator: creator.toEntity(),
      justifications: justifications.map((e) => e.toEntity()).toList(),
      externalAuthors: externalAuthors.map((e) => e.toEntity()).toList(),
      royaltyDistributions: royaltyDistributions
          .map((e) => e.toEntity())
          .toList(),
      applicationFields: applicationFields.map((e) => e.toEntity()).toList(),
    );
  }
}