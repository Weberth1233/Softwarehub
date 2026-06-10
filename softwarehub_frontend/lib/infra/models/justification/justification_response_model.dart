import 'package:nit_sgpi_frontend/domain/entities/justification/justification_response_entity.dart';

class JustificationResponseModel {
  final int id;
  final String reason;
  final DateTime createdAt;
  final JustificationAttachmentModel? attachment;

  JustificationResponseModel({
    required this.id,
    required this.reason,
    required this.createdAt,
    this.attachment,
  });

  factory JustificationResponseModel.fromJson(Map<String, dynamic> json) {
    return JustificationResponseModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      reason: json['reason']?.toString() ?? '',

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),

      attachment: json['attachment'] is Map<String, dynamic>
          ? JustificationAttachmentModel.fromJson(
              json['attachment'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'createdAt': createdAt.toIso8601String(),
      'attachment': attachment?.toJson(),
    };
  }

  JustificationResponseEntity toEntity() {
    return JustificationResponseEntity(
      id: id,
      reason: reason,
      createdAt: createdAt,
      attachment: attachment?.toEntity(),
    );
  }

  factory JustificationResponseModel.fromEntity(
    JustificationResponseEntity entity,
  ) {
    return JustificationResponseModel(
      id: entity.id,
      reason: entity.reason,
      createdAt: entity.createdAt,
      attachment: entity.attachment != null
          ? JustificationAttachmentModel.fromEntity(entity.attachment!)
          : null,
    );
  }
}
class JustificationAttachmentModel {
  final int id;
  final String fileName;
  final String? fileType;
  final int? fileSize;
  final String fileUrl;

  JustificationAttachmentModel({
    required this.id,
    required this.fileName,
    this.fileType,
    this.fileSize,
    required this.fileUrl,
  });

  factory JustificationAttachmentModel.fromJson(Map<String, dynamic> json) {
    return JustificationAttachmentModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      fileName: json['fileName']?.toString() ?? '',

      fileType: json['fileType']?.toString(),

      fileSize: json['fileSize'] != null
          ? int.tryParse(json['fileSize'].toString())
          : null,

      fileUrl: json['fileUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'fileUrl': fileUrl,
    };
  }

  JustificationAttachmentEntity toEntity() {
    return JustificationAttachmentEntity(
      id: id,
      fileName: fileName,
      fileType: fileType,
      fileSize: fileSize,
      fileUrl: fileUrl,
    );
  }

  factory JustificationAttachmentModel.fromEntity(
    JustificationAttachmentEntity entity,
  ) {
    return JustificationAttachmentModel(
      id: entity.id,
      fileName: entity.fileName,
      fileType: entity.fileType,
      fileSize: entity.fileSize,
      fileUrl: entity.fileUrl,
    );
  }
}