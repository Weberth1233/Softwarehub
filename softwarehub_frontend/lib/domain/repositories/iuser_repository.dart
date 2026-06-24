import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';
import '../core/repository/generic_repository.dart';
import '../entities/user/user_entity.dart';

abstract class IUserRepository implements
        IGenericPaginatedListRepository<UserEntity>,
        IGenericPutRepository<UserEntity, String>
         {
   Future<Either<Failure, UserEntity>> getUserLogged();
}