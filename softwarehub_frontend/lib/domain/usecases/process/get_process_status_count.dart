import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../entities/process/process_status_count_entity.dart';
import '../../repositories/iprocess_repository.dart';

class GetProcessStatusCount {
  final IProcessRepository repository;

  GetProcessStatusCount({required this.repository});

  Future<Either<Failure, List<ProcessStatusCountEntity>>> call() {
    return repository.getProcessesStatus();
  }
}
