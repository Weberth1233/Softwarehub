class JustificationResponseEntity {
  final int id;
  final String reason;
  final DateTime createdAt;
  final JustificationAttachmentEntity? attachment;

  JustificationResponseEntity({required this.id, required this.reason, required this.createdAt, required this.attachment});
}

class JustificationAttachmentEntity {
  final int id;
  final String fileName;
  final String? fileType;
  final int? fileSize;
  final String fileUrl;

  JustificationAttachmentEntity({
    required this.id,
    required this.fileName,
    this.fileType,
    this.fileSize,
    required this.fileUrl,
  });
}