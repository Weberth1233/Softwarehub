abstract class IGenericListRemoteDatasource<T> {
  Future<List<T>> getList();
}

abstract class IGenericPostRemoteDatasource<T> {
  Future<String> post(T entity);
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