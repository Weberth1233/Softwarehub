import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../repositories/iprocess_repository.dart';

class UpdateStatusProcess {
  final IProcessRepository repository;

  UpdateStatusProcess({required this.repository});

  Future<Either<Failure, String>> call(int processId, String newStatus) async{
    final result = await repository.updateStatusProcess(processId, newStatus);
    return result;
  }
}