import '../../entities/external_author_entity.dart';
import '../../repositories/iexternal_author_repository.dart';
import '../generic/generic_usecases.dart';

class PostExternalAuthor extends PostUsecase<ExternalAuthorEntity, String, IExternalAuthorRepository>{
  PostExternalAuthor({required super.repository});
 
}