import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/ip_type_entity.dart';
import '../../domain/repositories/iip_types_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/ip_types_remote_datasource.dart';

class IpTypesRepositoryImpl extends BaseRepository
    implements IIpTypesRepository {
  final IIpTypesRemoteDataSource remoteDataSource;

  IpTypesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<IpTypeEntity>>> getList() {
    return handleRequest(() {
      return remoteDataSource.getList();
    });
  }
}
