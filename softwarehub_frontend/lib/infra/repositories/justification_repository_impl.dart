import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/justification/justification_attachment_file_entity.dart';
import '../../domain/entities/justification/justification_request_entity.dart';
import '../../domain/repositories/ijustification_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/justiification_remote_datasource.dart';

class JustificationRepositoryImpl extends BaseRepository
    implements IJustificationRepository {
  final IJustificationRemoteDataSource remoteDataSource;
  JustificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> delete(int id) {
    return handleRequest(() {
      return remoteDataSource.delete(id);
    });
  }

  @override
  Future<Either<Failure, JustificationAttachmentFileEntity>> getById(int id) {
    return handleRequest(() {
      return remoteDataSource.getById(id);
    });
  }

  @override
  Future<Either<Failure, String>> post(JustificationRequestEntity entity) {
    return handleRequest(() {
      return remoteDataSource.post(entity);
    });
  }

  @override
  Future<Either<Failure, String>> put(
    int id,
    JustificationRequestEntity entity,
  ) {
    return handleRequest(() {
      return remoteDataSource.put(id, entity);
    });
  }
}
