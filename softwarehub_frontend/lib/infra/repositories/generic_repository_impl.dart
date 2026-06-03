import 'package:dartz/dartz.dart';

import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/repositories/generic_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/igeneric_remote_datasource.dart';

class GenericRepositoryImpl<T> implements IGenericRepository<T> {
  final IGenericRemoteDatasource<T> remoteDatasource;

  GenericRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, List<T>>> getList() async {
    try {
      final result = await remoteDatasource.getList();

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