import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/auth_user_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/auth_repository.dart';

import '../../core/errors/failures.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<Either<Failure, AuthUserEntity>> call(String email, String password) async{
    final result = await repository.login(email, password);
    result.fold(
      (_) {
      },
      (authUser) async{
        await repository.saveToken(authUser.token);
        await repository.saveRole(authUser.role);
      },
    );
    return result;
  }
}