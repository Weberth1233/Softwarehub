import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../repositories/generic_repository.dart';

class GetListUsecase<E, T extends IGenericRepository<E>> {
  final T repository;

  GetListUsecase({required this.repository});

  Future<Either<Failure, List<E>>> call() {
    return repository.getList();
  }
}
