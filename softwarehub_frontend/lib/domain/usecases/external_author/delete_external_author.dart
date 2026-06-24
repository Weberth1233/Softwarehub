
import 'package:nit_sgpi_frontend/domain/repositories/iexternal_author_repository.dart';

import '../generic/generic_usecases.dart';

class DeleteExternalAuthor extends DeleteUsecase<String, IExternalAuthorRepository>{
  DeleteExternalAuthor({required super.repository});
  
}