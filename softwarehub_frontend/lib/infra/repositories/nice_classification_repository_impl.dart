import '../../domain/entities/nice_classification_entity.dart';
import '../../domain/repositories/inice_classification_repository.dart';
import '../datasources/nice_classification_remote_datasource.dart';
import 'generic_repository_impl.dart';

class NiceClassificationRepositoryImpl
    extends GenericRepositoryImpl<NiceClassificationEntity>
    implements INiceClassificationRepository {
  NiceClassificationRepositoryImpl({

    required INiceClassificationRemoteDatasource remoteDataSource,
  }) : super(remoteDataSource: remoteDataSource);
}
