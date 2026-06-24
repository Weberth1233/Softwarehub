import 'package:dartz/dartz.dart';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/paged_result_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/iuser_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl extends BaseRepository implements IUserRepository {
  final IUserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedResultEntity<UserEntity>>> getPaginatedList(
    Map<String, String> values,
  ) {
    return handleRequest(() {
      return remoteDataSource.getPaginatedList(values);
    });
  }

  @override
  Future<Either<Failure, UserEntity>> getUserLogged() {
   return handleRequest(() {
      return remoteDataSource.getUserLogged();
    });
  }

  @override
  Future<Either<Failure, String>> put(int id, UserEntity entity) {
    return handleRequest(() {
      return remoteDataSource.put(id, entity);
    });
  }

  // @override
  // Future<Either<Failure, PagedResultEntity<UserEntity>>> getUsers({
  //   String search = "",
  //   int page = 0,
  //   int size = 8,
  // }) async {
  //   try {
  //     final values = <String, String>{
  //       'page': page.toString(),
  //       'page-size': size.toString(),
  //       'search': search,
  //     };
  //     final resultEntity = await remoteDataSource.getPaginatedList(values);
  //     return Right(resultEntity);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } on NetworkException catch (e) {
  //     return Left(NetworkFailure(e.message));
  //   } catch (e) {
  //     return Left(ServerFailure("Erro inesperado!"));
  //   }
  // }

  // @override
  // Future<Either<Failure, UserEntity>> getUserLogged() async {
  //   try {
  //     final result = await remoteDataSource.getUserLogged();
  //     return Right(result);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } on NetworkException catch (e) {
  //     return Left(NetworkFailure(e.message));
  //   } catch (e) {
  //     return Left(ServerFailure("Erro inesperado!"));
  //   }
  // }

  // @override
  // Future<Either<Failure, String>> updateUser(
  //   int idUser,
  //   UserEntity user,
  // ) async {
  //   try {
  //     final result = await remoteDataSource.put(idUser, user);
  //     return Right(result);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } on NetworkException catch (e) {
  //     return Left(NetworkFailure(e.message));
  //   } catch (e) {
  //     return Left(ServerFailure("Erro inesperado!"));
  //   }
  // }
}
