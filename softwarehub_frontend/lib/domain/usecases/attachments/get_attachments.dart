import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iattachment_repository.dart';

import '../../core/errors/failures.dart';

class GetAttachments {
  final IAttachmentRepository repository;

  GetAttachments( this.repository);

  Future<Either<Failure, List<AttachmentEntity>>> call(int idProcess) {
    return repository.getAttachments(idProcess);
  }
}
