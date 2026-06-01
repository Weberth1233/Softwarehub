import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iuser_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/user_remote_datasource.dart';
import '../../domain/core/errors/exceptions.dart';

class UserRepositoryImpl implements IUserRepository{

  final IUserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedResultEntity<UserEntity>>> getUsers({String search="", int page = 0, int size = 8}) async{
    try{
      final resultEntity = await remoteDataSource.getUsers(search:search, size: size, page: page);
      return Right(resultEntity);
    }on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
  
  @override
  Future<Either<Failure, UserEntity>> getUserLogged() async{
   try {
      final result = await remoteDataSource.getUserLogged();
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
  Future<Either<Failure, String>> updateUser(int idUser, UserEntity user) async{
    try {
      final result = await remoteDataSource.updateUser(idUser, user);
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