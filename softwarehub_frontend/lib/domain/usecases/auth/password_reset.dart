import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class PasswordReset {
  final AuthRepository repository;

  PasswordReset({required this.repository});

  Future<Either<Failure, String>> call(String token, String newPassword) async{
    final result = await repository.passwordReset(token, newPassword);
    return result;
  }
}