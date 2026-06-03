import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/iuser_repository.dart';

class PutUser {
  final IUserRepository repository;

  PutUser({required this.repository});

  Future<Either<Failure, String>> call(int idUser, UserEntity user) {
    return repository.updateUser(idUser, user);
  }
}