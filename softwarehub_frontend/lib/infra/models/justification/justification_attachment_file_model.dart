import 'dart:convert';

import '../../../domain/entities/justification/justification_attachment_file_entity.dart';

class JustificationAttachmentFileModel {
  final List<int> bytes;
  final String contentType;
  final String? fileName;

  JustificationAttachmentFileModel({
    required this.bytes,
    required this.contentType,
    this.fileName,
  });

  factory JustificationAttachmentFileModel.fromJson(Map<String, dynamic> json) {
    return JustificationAttachmentFileModel(
      bytes: _parseBytes(json["bytes"]),
      contentType: json["contentType"] ?? json["content_type"] ?? "",
      fileName: json["fileName"] ?? json["file_name"],
    );
  }

  JustificationAttachmentFileEntity toEntity() {
    return JustificationAttachmentFileEntity(
      bytes: bytes,
      contentType: contentType,
      fileName: fileName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bytes": base64Encode(bytes),
      "contentType": contentType,
      "fileName": fileName,
    };
  }

  static List<int> _parseBytes(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((e) => e as int).toList();
    }

    if (value is String) {
      return base64Decode(value);
    }

    throw Exception("Formato inválido para bytes");
  }
}
