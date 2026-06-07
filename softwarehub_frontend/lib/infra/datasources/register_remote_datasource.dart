import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/infra/core/network/api_client.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_model.dart';
import 'package:nit_sgpi_frontend/infra/utils/error_formatter.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/network/base_url.dart';

abstract class IRegisterRemoteDataSource {
  Future<String> postUser(UserEntity user);
}

class RegisterRemoteDatasource implements IRegisterRemoteDataSource {
  final ApiClient apiClient;

  RegisterRemoteDatasource(this.apiClient);

  @override
  Future<String> postUser(UserEntity user) async {
    try {
      final model = UserModel.fromEntity(user);
      final response = await apiClient.post(
        "${BaseUrl.urlWithHttp}/auth/register",
        authenticated: false,
        body: model.toJson(),
      );
      if (response.statusCode == 201) {
        return "Cadastrado com sucesso!";
      } else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
