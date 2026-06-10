import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification/justification_request_entity.dart';
import '../core/errors/failures.dart';
import '../entities/justification/justification_attachment_file_entity.dart';

abstract class IJustificationRepository {
  Future<Either<Failure, String>> postJustification(
    JustificationRequestEntity entity,
  );
  Future<Either<Failure, String>> deleteJustification(int justificationId);
  Future<Either<Failure, JustificationAttachmentFileEntity>> getAttachmentFile(
    int attachmentId,
  );
  //  Future<Either<Failure, String>> putJustification(int idJustification, JustificationRequestEntity justification);
}
