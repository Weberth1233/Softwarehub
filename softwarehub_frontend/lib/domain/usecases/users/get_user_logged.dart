import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/iuser_repository.dart';

class GetUserLogged {
  final IUserRepository repository;

  GetUserLogged({required this.repository});

  Future<Either<Failure, UserEntity>> call() {
    return repository.getUserLogged();
  }
}