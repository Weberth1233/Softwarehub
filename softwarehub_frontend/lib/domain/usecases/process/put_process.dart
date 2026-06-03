import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../entities/process/process_request_entity.dart';
import '../../repositories/iprocess_repository.dart';

class PutProcess {
  final IProcessRepository repository;

  PutProcess({required this.repository});

  Future<Either<Failure, String>> call(int processId, ProcessRequestEntity entity) async{
    final result = await repository.putProcess(processId,entity);
    return result;
  }
}