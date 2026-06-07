import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/infra/datasources/types_link_remote_datasource.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/types_link_entity.dart';
import '../../domain/repositories/itypes_link_repository.dart';
import '../core/repositories/base_repository.dart';

class TypesLinkRepositoryImpl
    extends BaseRepository
    implements ITypesLinkRepository {

  final ITypesLinkRemoteDatasource remoteDataSource;

  TypesLinkRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TypesLinkEntity>>> getList() {
    return handleRequest(() {
      return remoteDataSource.getList();
    },);
    
  }
}
