import '../../../domain/entities/paged_result_entity.dart';

abstract class IGenericListRemoteDatasource<T> {
  Future<List<T>> getList();
}

abstract class IGenericPostRemoteDatasource<TRequest, TResponse> {
  Future<TResponse> post(TRequest entity);
}

abstract class IGenericPutRemoteDatasource<T> {
  Future<String> put(int id, T entity);
}

abstract class IGenericDeleteRemoteDatasource {
  Future<String> delete(int id);
}

abstract class IGenericGetByIdRemoteDatasource<T> {
  Future<T> getById(int id);
}

abstract class IGenericPaginatedList<T>{
  Future<PagedResultEntity<T>> getPaginatedList(Map<String, String> values);
}

abstract class IGenericUploadRemoteDatasource<TRequest, TResponse> {
  Future<TResponse> upload(TRequest entity);
}