import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/external_author_entity.dart';
import '../../domain/entities/paged_result_entity.dart';
import '../../domain/repositories/iexternal_author_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/external_author_datasource.dart';

class ExternalAuthorRepositoryImpl extends BaseRepository
    implements IExternalAuthorRepository {
  final IExternalAuthorRemoteDataSource remoteDataSource;

  ExternalAuthorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> delete(int id) {
    return handleRequest(() {
      return remoteDataSource.delete(id);
    });
  }

  @override
  Future<Either<Failure, PagedResultEntity<ExternalAuthorEntity>>>
  getPaginatedList(Map<String, String> values) {
    return handleRequest(() {
      return remoteDataSource.getPaginatedList(values);
    });
  }

  @override
  Future<Either<Failure, String>> post(ExternalAuthorEntity entity) {
    return handleRequest(() {
      return remoteDataSource.post(entity);
    });
  }

  @override
  Future<Either<Failure, String>> put(int id, ExternalAuthorEntity entity) {
    return handleRequest(() {
      return remoteDataSource.put(id, entity);
    });
  }
}
