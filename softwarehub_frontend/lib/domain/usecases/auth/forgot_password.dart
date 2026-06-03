import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository repository;

  ForgotPassword({required this.repository});

  Future<Either<Failure, String>> call(String email) async{
    final result = await repository.forgotPassword(email);
    return result;
  }
}