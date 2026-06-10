class JustificationAttachmentFileEntity {
   final List<int> bytes;
  final String contentType;
  final String? fileName;

  JustificationAttachmentFileEntity({
    required this.bytes,
    required this.contentType,
    this.fileName,
  });

  bool get isImage => contentType.startsWith('image/');

  bool get isPdf => contentType == 'application/pdf';
}