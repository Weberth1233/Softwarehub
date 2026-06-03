import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iprocess_repository.dart';

import '../../core/errors/failures.dart';

class PostProcess {
  final IProcessRepository repository;

  PostProcess({required this.repository});

  Future<Either<Failure, String>> call(ProcessRequestEntity entity) async{
    final result = await repository.postProcess(entity);
    return result;
  }
}