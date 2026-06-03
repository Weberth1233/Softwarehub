import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../entities/external_author/external_author_entity.dart';
import '../../repositories/iexternal_author_repository.dart';

class PostExternalAuthor {
  final IExternalAuthorRepository repository;

  PostExternalAuthor({required this.repository});

  Future<Either<Failure, String>> call(ExternalAuthorEntity entity) async{
    final result = await repository.postExternalAuthor(entity);
    return result;
  }
}