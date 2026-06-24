import 'package:nit_sgpi_frontend/domain/entities/external_author_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iexternal_author_repository.dart';

import '../generic/generic_usecases.dart';

class GetExternalAuthors extends GetPaginatedList<ExternalAuthorEntity, IExternalAuthorRepository> {
  GetExternalAuthors({required super.repository});
  
}