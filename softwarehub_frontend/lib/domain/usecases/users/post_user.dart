import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iregister_repository.dart';
import '../../core/errors/failures.dart';

class PostUser {
  final IRegisterRepository repository;

  PostUser({required this.repository});

  Future<Either<Failure, String>> call(UserEntity user) async{
    final result = await repository.postUser(user);
    return result;
  }
}