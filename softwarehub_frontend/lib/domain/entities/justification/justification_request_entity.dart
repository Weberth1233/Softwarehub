class JustificationRequestEntity {
  final int processId;
  final String reason;

  final String? filePath;
  final List<int>? fileBytes;
  final String? fileName;

  JustificationRequestEntity({
    required this.processId,
    required this.reason,
    this.filePath,
    this.fileBytes,
    this.fileName,
  });
}