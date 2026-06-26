import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/paged_result_entity.dart';
import '../../domain/entities/process/process_request_entity.dart';
import '../../domain/entities/process/process_response_entity.dart';
import '../../domain/entities/process/process_status_count_entity.dart';
import '../../domain/repositories/iprocess_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/process_remote_datasource.dart';

class ProcessRepositoryImpl extends BaseRepository
    implements IProcessRepository {
  final IProcessRemoteDataSource remoteDataSource;

  ProcessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> delete(int id) {
    return handleRequest(() {
      return remoteDataSource.delete(id);
    });
  }

  @override
  Future<Either<Failure, ProcessResponseEntity>> getById(int id) {
    return handleRequest(() {
      return remoteDataSource.getById(id);
    });
  }

  @override
  Future<Either<Failure, PagedResultEntity<ProcessResponseEntity>>>
  getPaginatedList(Map<String, String> values) {
    return handleRequest(() {
      return remoteDataSource.getPaginatedList(values);
    });
  }

  @override
  Future<Either<Failure, List<ProcessStatusCountEntity>>> getProcessesStatus() {
    return handleRequest(() {
      return remoteDataSource.getProcessesStatusCount();
    });
  }

  @override
  Future<Either<Failure, int>> post(ProcessRequestEntity entity) {
    return handleRequest(() {
      return remoteDataSource.post(entity);
    });
  }

  @override
  Future<Either<Failure, String>> processClassification(
    int processId,
    List<int> applicationFields, {
    bool isEdit = false,
  }) {
    return handleRequest(() {
      return remoteDataSource.processClassification(
        processId,
        applicationFields,
        isEdit: isEdit,
      );
    });
  }

  @override
  Future<Either<Failure, String>> put(int id, ProcessRequestEntity entity) {
    return handleRequest(() {
      return remoteDataSource.put(id, entity);
    });
  }

  @override
  Future<Either<Failure, String>> updateStatusProcess(
    int processId,
    String newStatus,
  ) {
    return handleRequest(() {
      return remoteDataSource.updateStatusProcess(processId, newStatus);
    });
  }
}
