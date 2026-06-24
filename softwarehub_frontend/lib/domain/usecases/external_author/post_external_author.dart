import 'package:nit_sgpi_frontend/domain/usecases/generic/generic_usecases.dart';
import '../../entities/external_author_entity.dart';
import '../../repositories/iexternal_author_repository.dart';

class PostExternalAuthor extends PostUsecase<ExternalAuthorEntity, String, IExternalAuthorRepository>{
  PostExternalAuthor({required super.repository});
 
}