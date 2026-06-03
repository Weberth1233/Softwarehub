import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_response_entity.dart';

import '../../core/errors/failures.dart';
import '../../repositories/iprocess_repository.dart';

class GetProcessById {
  final IProcessRepository repository;

  GetProcessById({required this.repository});

  Future<Either<Failure, ProcessResponseEntity>> call(int processId) {
    return repository.getProcessById(processId);
  }
}