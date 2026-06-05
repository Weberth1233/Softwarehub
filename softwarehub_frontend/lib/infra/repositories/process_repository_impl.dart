import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_response_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_status_count_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iprocess_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/process_remote_datasource.dart';

class ProcessRepositoryImpl implements IProcessRepository {
  final IProcessRemoteDataSource remoteDataSource;

  ProcessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedResultEntity<ProcessResponseEntity>>>
  getProcesses({
    String title = "",
    String statusGenero = "",
    int page = 0,
    int size = 10,
  }) async {
    try {
      final resultEntity = await remoteDataSource
          .getProcesses(
            title: title,
            statusProcess: statusGenero,
            page: page,
            size: size,
          );
      return Right(resultEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }

  @override
  Future<Either<Failure, List<ProcessStatusCountEntity>>>
  getProcessesStatus() async {
    try {
      final result = await remoteDataSource.getProcessesStatusCount();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }

  @override
  Future<Either<Failure, int>> postProcess(
    ProcessRequestEntity entity,
  ) async {
    try {
      final result = await remoteDataSource.postProcess(entity);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }

  

  @override
  Future<Either<Failure, ProcessResponseEntity>> getProcessById(
    int processId,
  ) async {
    try {
      final result = await remoteDataSource.getProcessById(processId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProcessById(int processId) async {
    try {
      final result = await remoteDataSource.deleteProcess(processId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
  
  @override
  Future<Either<Failure, String>> updateStatusProcess(int processId, String newStatus) async{
    try {
      final result = await remoteDataSource.updateStatusProcess(processId, newStatus);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
  
  @override
  Future<Either<Failure, String>> putProcess(int idProcess, ProcessRequestEntity entity) async{
   try {
      final result = await remoteDataSource.putProcess(idProcess, entity);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
  
  @override
  Future<Either<Failure, String>> processClassification(int processId, int niceClassCode) async{
    try {
      final result = await remoteDataSource.processClassification(processId, niceClassCode);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
}
