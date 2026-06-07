/*import 'package:dartz/dartz.dart';

import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/core/repository/generic_repository.dart';
import 'package:nit_sgpi_frontend/infra/core/datasources/igeneric_remote_datasource.dart';

class GenericListRepositoryImpl<T> implements IGenericListRepository<T> {
  final IGenericListRemoteDatasource<T> remoteDataSource;

  GenericListRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<T>>> getList() async {
    try {
      final result = await remoteDataSource.getList();

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

class GenericPosttRepositoryImpl<T> implements IGenericPostRepository<T> {
  final IGenericPostRemoteDatasource<T> remoteDataSource;

  GenericPosttRepositoryImpl({
    required this.remoteDataSource,
  });
  
  @override
  Future<Either<Failure, String>> post(T entity) async{
    try {
      final result = await remoteDataSource.post(entity);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
}*/