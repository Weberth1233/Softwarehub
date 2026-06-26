import '../../domain/entities/paged_result_entity.dart';
import '../../domain/entities/user/user_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/user/user_model.dart';

abstract class IUserRemoteDataSource
    implements
        IGenericPaginatedList<UserEntity>,
        IGenericPutRemoteDatasource<UserEntity> {
  

  Future<UserEntity> getUserLogged();
}

class UserRemoteDatasourcesImpl implements IUserRemoteDataSource {
  final RemoteDatasourceHelper helper;

  UserRemoteDatasourcesImpl(ApiClient apiClient)
    : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<PagedResultEntity<UserEntity>> getPaginatedList(
    Map<String, String> values,
  ) {
    
    final uri = Uri.http(BaseUrl.url, "/users", values);
    return helper.getPagedList<UserModel, UserEntity>(
      url: uri.toString(),
      fromJson: UserModel.fromJson,
      toEntity: (model) => model.toEntity(),
      errorMessage: "Erro ao buscar dados de usuários!",
    );
  }

  @override
  Future<UserEntity> getUserLogged() async {
    final uri = Uri.http(BaseUrl.url, "/users/logged");

    return helper.getById<UserEntity, UserModel>(
      url: uri.toString(),
      fromJson: UserModel.fromJson,
      toEntity: (model) => model.toEntity(),
      errorMessage: "Erro ao buscar dados do usuário logado!",
    );
  }

  @override
  Future<String> put(int id, UserEntity entity) {
    final uri = Uri.http(BaseUrl.url, "/users/$id");
    final model = UserModel.fromEntity(entity);

    return helper.put(
      url: uri.toString(),
      body: model.toJson(),
      onSuccess: (responseBody, statusCode) {
        if (statusCode == 204 || responseBody == null) {
          return 'Atualizado com sucesso!';
        }
        if (responseBody is Map<String, dynamic>) {
          return responseBody['message']?.toString() ??
              'Atualizado com sucesso!';
        }
        return responseBody.toString();
      },
    );
  }
}
