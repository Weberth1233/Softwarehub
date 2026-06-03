import 'package:nit_sgpi_frontend/infra/models/base_model.dart';
import 'package:nit_sgpi_frontend/infra/models/external_author_model.dart';
import 'package:nit_sgpi_frontend/infra/models/ip_types/ip_types_model.dart';
import 'package:nit_sgpi_frontend/infra/models/process/process_justification_model.dart';

import '../../../domain/entities/process/process_response_entity.dart';
import '../attachment_model.dart';
import 'process_user_model.dart';

class ProcessResponseModel implements BaseModel{
  @override
  final int id;
  final String title;
  final String status;
  final bool isFeatured;
  final DateTime createdAt;
  final Map<String, dynamic> formData;
  final IpTypeModel ipType;
  final List<ProcessUserModel> authors;
  final List<AttachmentModel> attachments;
  final List<ProcessJustificationModel> justifications;
  final List<ExternalAuthorModel> externalAuthors;
  final ProcessUserModel creator;

  ProcessResponseModel({
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

  factory ProcessResponseModel.fromJson(Map<String, dynamic> json) {
    return ProcessResponseModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      isFeatured: json['isFeatured'],
      createdAt: DateTime.parse(json['createdAt']),
      formData: Map<String, dynamic>.from(json['formData'] ?? {}),
      ipType: IpTypeModel.fromJson(json['ipType']),
      authors: (json['authors'] as List)
          .map((e) => ProcessUserModel.fromJson(e))
          .toList(),
      attachments: (json['attachments'] as List)
          .map((e) => AttachmentModel.fromJson(e))
          .toList(),
      justifications: (json['justifications'] as List)
          .map((e) => ProcessJustificationModel.fromJson(e))
          .toList(),
      creator: ProcessUserModel.fromJson(json['creator']),

      externalAuthors: (json['externalAuthors'] as List)
          .map((e) => ExternalAuthorModel.fromJson(e))
          .toList(),
    );
  }

 /* factory ProcessModel.fromEntity(ProcessEntity entity) {
    return ProcessModel(
      id: entity.id,
      title: entity.title,
      status: entity.status,
      isFeatured: entity.isFeatured,
      createdAt: entity.createdAt,
      formData: entity.formData,
      ipType: IpTypeModel.fromEntity(entity.ipType),
      authors: entity.authors.map((e) => UserModel.fromEntity(e)).toList(),
      attachments: entity.attachments
          .map((e) => AttachmentModel.fromEntity(e))
          .toList(),
      creator: UserModel.fromEntity(entity.creator),
    );
  }
*/

  @override
  ProcessResponseEntity toEntity() {
    return ProcessResponseEntity(
      id: id,
      title: title,
      status: status,
      isFeatured: isFeatured,
      createdAt: createdAt,
      formData: formData,
      ipType: ipType.toEntity(),
      authors: authors.map((e) => e.toEntity()).toList(),
      attachments: attachments.map((e) => e.toEntity()).toList(),
      creator: creator.toEntity(),
      justifications: justifications.map((e) => e.toEntity(),).toList(),
      externalAuthors: externalAuthors.map((e) => e.toEntity(),).toList(),
    );
  }
}
