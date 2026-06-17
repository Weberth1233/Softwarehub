import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/application_field_entity.dart';
import '../../domain/entities/paged_result_entity.dart';
import '../../domain/repositories/iapplication_field_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/application_field_remote_datasource.dart';

class ApplicationFieldRepositoryImpl extends BaseRepository implements IApplicationFieldRepository {
  final IApplicationFieldRemoteDataSource remoteDataSource;

  ApplicationFieldRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PagedResultEntity<ApplicationFieldEntity>>> getPaginatedList(Map<String, String> values) {
    return handleRequest(() {
      return remoteDataSource.getPaginatedList(values);
    },);
  }
  
}