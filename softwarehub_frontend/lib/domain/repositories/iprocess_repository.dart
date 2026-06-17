import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';
import '../entities/paged_result_entity.dart';
import '../entities/process/process_request_entity.dart';
import '../entities/process/process_response_entity.dart';
import '../entities/process/process_status_count_entity.dart';

abstract class IProcessRepository {
  Future<Either<Failure, PagedResultEntity<ProcessResponseEntity>>> getProcesses({String title,String statusGenero, int page = 0, int size = 10});
  Future<Either<Failure, List<ProcessStatusCountEntity>>> getProcessesStatus();
  Future<Either<Failure, String>> updateStatusProcess(int processId, String newStatus);
  Future<Either<Failure, int>> postProcess(ProcessRequestEntity entity);
  Future<Either<Failure, String>> putProcess(int processId, ProcessRequestEntity entity);
  Future<Either<Failure, ProcessResponseEntity>> getProcessById(int processId); 
  Future<Either<Failure, String>> deleteProcessById(int processId); 
  Future<Either<Failure, String>> processClassification(int processId,  List<int> applicationFields, {
    bool isEdit = false,
  });
}