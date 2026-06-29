import 'package:dartz/dartz.dart';

import '../../domain/core/errors/failures.dart';
import '../../domain/entities/user/user_entity.dart';
import '../../domain/repositories/iregister_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/register_remote_datasource.dart';

class RegisterRepositoryImpl extends BaseRepository
    implements IRegisterRepository {
  final IRegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> post(UserEntity userEntity) async {
    return handleRequest(() {
      return remoteDataSource.post(userEntity);
    });
  }
}
