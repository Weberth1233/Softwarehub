import '../../domain/entities/ip_type_entity.dart';
import '../../domain/repositories/iip_types_repository.dart';
import '../datasources/ip_types_remote_datasource.dart';
import 'generic_repository_impl.dart';

class IpTypesRepositoryImpl
    extends GenericRepositoryImpl<IpTypeEntity>
    
    implements IIpTypesRepository {
  IpTypesRepositoryImpl({

    required IIpTypesRemoteDataSource remoteDatasource,
  }) : super(remoteDatasource: remoteDatasource);
}