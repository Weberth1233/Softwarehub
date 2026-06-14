import 'package:dartz/dartz.dart';

import '../../entities/paged_result_entity.dart';
import '../errors/failures.dart';

abstract class IGenericListRepository<T> {
  Future<Either<Failure, List<T>>> getList();
}

abstract class IGenericPaginatedListRepository<T>{
  Future<Either<Failure, PagedResultEntity<T>>> getPaginatedList(Map<String, String> values);
}

abstract class IGenericPostRepository<TRequest, TResponse> {
  Future<Either<Failure, TResponse>> post(TRequest entity);
}

abstract class IGenericPutRepository<TRequest, TResponse> {
  Future<Either<Failure, TResponse>> put(int id, TRequest entity);
}

abstract class IGenericDeleteRepository<TResponse> {
  Future<Either<Failure, TResponse>> delete(int id);
}

abstract class IGenericGetByIdRepository<TResponse> {
  Future<Either<Failure, TResponse>> getById(int id);
}