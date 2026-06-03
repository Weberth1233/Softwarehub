import '../../domain/entities/types_link_entity.dart';
import '../../domain/repositories/itypes_link_repository.dart';
import '../datasources/types_link_remote_datasource.dart';
import 'generic_repository_impl.dart';

class TypesLinkRepositoryImpl
    extends GenericRepositoryImpl<TypesLinkEntity>
    implements ITypesLinkRepository {
  TypesLinkRepositoryImpl({

    required ITypesLinkRemoteDatasource remoteDatasource,
  }) : super(remoteDatasource: remoteDatasource);
}
