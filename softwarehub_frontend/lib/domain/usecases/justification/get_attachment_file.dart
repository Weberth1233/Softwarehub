import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../entities/justification/justification_attachment_file_entity.dart' show JustificationAttachmentFileEntity;
import '../../repositories/ijustification_repository.dart';

class GetAttachmentFile {
  final IJustificationRepository repository;

  GetAttachmentFile({required this.repository});

  Future<Either<Failure, JustificationAttachmentFileEntity>> call(int attachmentId) async{
    final result = await repository.getAttachmentFile(attachmentId);
    return result;
  }
}