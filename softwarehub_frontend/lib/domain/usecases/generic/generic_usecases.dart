import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/repository/generic_repository.dart';

class GetListUsecase<E, R extends IGenericListRepository<E>> {
  final R repository;

  GetListUsecase({required this.repository});

  Future<Either<Failure, List<E>>> call() {
    return repository.getList();
  }
}

class PostUsecase<Request, Response,
    R extends IGenericPostRepository<Request, Response>> {
  final R repository;

  PostUsecase({required this.repository});

  Future<Either<Failure, Response>> call(Request entity) {
    return repository.post(entity);
  }
}

class PutUsecase<Request, Response,
    R extends IGenericPutRepository<Request, Response>> {
  final R repository;

  PutUsecase({required this.repository});

  Future<Either<Failure, Response>> call(int id, Request entity) {
    return repository.put(id, entity);
  }
}

class DeleteUsecase<Response,
    R extends IGenericDeleteRepository<Response>> {
  final R repository;

  DeleteUsecase({required this.repository});

  Future<Either<Failure, Response>> call(int id) {
    return repository.delete(id);
  }
}

class GetByIdUsecase<Response,
    R extends IGenericGetByIdRepository<Response>> {
  final R repository;

  GetByIdUsecase({required this.repository});

  Future<Either<Failure, Response>> call(int id) {
    return repository.getById(id);
  }
}