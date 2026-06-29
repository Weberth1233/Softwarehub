import '../../domain/entities/user/user_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/user/user_model.dart';

abstract class IRegisterRemoteDataSource
    implements IGenericPostRemoteDatasource<UserEntity, String> {}

class RegisterRemoteDatasource implements IRegisterRemoteDataSource {
  final RemoteDatasourceHelper helper;

  RegisterRemoteDatasource(ApiClient apiClient)
    : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<String> post(UserEntity user) async {
    final uri = Uri.http(BaseUrl.url, "/auth/register");
    final model = UserModel.fromEntity(user);

    return helper.post<String>(
      url: uri.toString(),
      body: model.toJson(),
      onSuccess: (responseBody) {
        if (responseBody is Map<String, dynamic>) {
          return responseBody['message']?.toString() ??
              'Cadastro realizado com sucesso!';
        }
        if (responseBody is String && responseBody.trim().isNotEmpty) {
          return responseBody;
        }
        return 'Cadastro realizado com sucesso!';
      },
    );
  }
}
