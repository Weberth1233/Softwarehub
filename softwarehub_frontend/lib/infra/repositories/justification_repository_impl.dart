import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification/justification_attachment_file_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/ijustification_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/justiification_remote_datasource.dart';
import '../../domain/core/errors/exceptions.dart';

class JustificationRepositoryImpl implements IJustificationRepository {
  final IJustificationRemoteDataSource remoteDataSource;
  JustificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> postJustification(
    JustificationRequestEntity entity,
  ) async {
    try {
      final result = await remoteDataSource.postJustification(entity);
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
  Future<Either<Failure, String>> deleteJustification(
    int idJustification,
  ) async {
    try {
      final result = await remoteDataSource.deleteJustification(
        idJustification,
      );
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
  Future<Either<Failure, JustificationAttachmentFileEntity>> getAttachmentFile(int attachmentId) async{
   try {
      final result = await remoteDataSource.getAttachmentFile(
        attachmentId,
      );
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
  Future<Either<Failure, String>> putJustification(int justificationId, JustificationRequestEntity justification) async{
     try {
      final result = await remoteDataSource.putJustificattion(
        justificationId,
        justification,
      );
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
