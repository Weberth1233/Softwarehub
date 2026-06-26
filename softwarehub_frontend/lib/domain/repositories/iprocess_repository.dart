import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';
import '../core/repository/generic_repository.dart';
import '../entities/process/process_request_entity.dart';
import '../entities/process/process_response_entity.dart';
import '../entities/process/process_status_count_entity.dart';

abstract class IProcessRepository
    implements
        IGenericPaginatedListRepository<ProcessResponseEntity>,
        IGenericPostRepository<ProcessRequestEntity, int>,
        IGenericPutRepository<ProcessRequestEntity, String>,
        IGenericGetByIdRepository<ProcessResponseEntity>,
        IGenericDeleteRepository<String> {
  
  Future<Either<Failure, List<ProcessStatusCountEntity>>> getProcessesStatus();
  Future<Either<Failure, String>> updateStatusProcess(
    int processId,
    String newStatus,
  );
  Future<Either<Failure, String>> processClassification(
    int processId,
    List<int> applicationFields, {
    bool isEdit = false,
  });
}
