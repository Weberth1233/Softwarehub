import '../../entities/external_author_entity.dart';
import '../../repositories/iexternal_author_repository.dart';
import '../generic/generic_usecases.dart';

class PutExternalAuthor
    extends
        PutUsecase<ExternalAuthorEntity, String, IExternalAuthorRepository> {
  PutExternalAuthor({required super.repository});
}
