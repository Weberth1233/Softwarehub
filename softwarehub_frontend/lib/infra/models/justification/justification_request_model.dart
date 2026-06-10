import 'package:nit_sgpi_frontend/domain/entities/justification/justification_request_entity.dart';

class JustificationRequestModel {
  final int processId;
  final String reason;
  final String? filePath;
  final List<int>? fileBytes;
  final String? fileName;

  JustificationRequestModel({required this.processId, required this.reason, this.filePath, this.fileBytes, this.fileName});


  factory JustificationRequestModel.fromEntity(JustificationRequestEntity entity) {
    return JustificationRequestModel(
      processId: entity.processId,
      reason: entity.reason,
      fileBytes: entity.fileBytes,
      fileName: entity.fileName,
      filePath: entity.filePath,
    );
  }

}