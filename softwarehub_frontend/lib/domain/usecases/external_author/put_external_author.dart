import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iexternal_author_repository.dart';

import '../../core/errors/failures.dart';

class PutExternalAuthor {
  final IExternalAuthorRepository repository;

  PutExternalAuthor({required this.repository});
  
  Future<Either<Failure, String>> call(int id,ExternalAuthorEntity entity) async{
    final result = await repository.putExternalAuthor(id, entity);
    return result;
  }
}