
import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iexternal_author_repository.dart';

import '../../core/errors/failures.dart';

class DeleteExternalAuthor {
  final IExternalAuthorRepository repository;

  DeleteExternalAuthor({required this.repository});

  Future<Either<Failure, String>> call(int id) async{
    final result = await repository.deleteExternalAuthor(id);
    return result;
  }
}