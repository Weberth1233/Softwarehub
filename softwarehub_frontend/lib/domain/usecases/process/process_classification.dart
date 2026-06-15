import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../repositories/iprocess_repository.dart';

class ProcessClassification {
  final IProcessRepository repository;

  ProcessClassification({required this.repository});

  Future<Either<Failure, String>> call(int processId, List<int> applicationFields) async {
    final result = await repository.processClassification(
      processId,
      applicationFields,
    );
    return result;
  }
}
