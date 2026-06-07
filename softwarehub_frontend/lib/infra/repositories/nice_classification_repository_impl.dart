import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/infra/core/repositories/base_repository.dart';
import '../../domain/entities/nice_classification_entity.dart';
import '../../domain/repositories/inice_classification_repository.dart';
import '../datasources/nice_classification_remote_datasource.dart';

class NiceClassificationRepositoryImpl
    extends BaseRepository
    implements INiceClassificationRepository {

  final INiceClassificationRemoteDatasource remoteDataSource;

  NiceClassificationRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Either<Failure, List<NiceClassificationEntity>>> getList() {
    return handleRequest(() {
      return remoteDataSource.getList();
    },);
  }

  
}
