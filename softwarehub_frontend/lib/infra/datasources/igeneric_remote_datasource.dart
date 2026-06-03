abstract class IGenericRemoteDatasource <T> {
    Future<List<T>> getList();
}