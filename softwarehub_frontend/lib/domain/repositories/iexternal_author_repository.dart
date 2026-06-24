import '../core/repository/generic_repository.dart';
import '../entities/external_author_entity.dart';

abstract class IExternalAuthorRepository
    implements
        IGenericPaginatedListRepository<ExternalAuthorEntity>,
        IGenericPostRepository<ExternalAuthorEntity, String>,
        IGenericPutRepository<ExternalAuthorEntity, String>,
        IGenericDeleteRepository<String> {}
