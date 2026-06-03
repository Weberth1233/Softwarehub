import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iuser_repository.dart';

import '../../core/errors/failures.dart';
import '../../entities/paged_result_entity.dart';

class GetUsers {
  final IUserRepository repository;

  GetUsers({required this.repository});

  Future<Either<Failure, PagedResultEntity<UserEntity>>> call({
    String search = "",
    int page = 0,
    int size = 8,
  }) {
    return repository.getUsers(search: search, page: page,size: size);
  }
}