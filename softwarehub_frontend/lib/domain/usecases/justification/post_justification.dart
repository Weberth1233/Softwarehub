import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/ijustification_repository.dart';

import '../../core/errors/failures.dart';

class PostJustification {
  final IJustificationRepository repository;

  PostJustification({required this.repository});

  Future<Either<Failure, String>> call(JustificationRequestEntity entity) async{
    final result = await repository.postJustification(entity);
    return result;
  }
}