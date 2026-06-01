import 'dart:convert';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../models/paged_result_model.dart';

abstract class IUserRemoteDataSource {
  Future<PagedResultEntity<UserEntity>> getUsers({
    String search,
    int page = 0,
    int size = 8,
  });

  Future<UserEntity> getUserLogged();
  Future<String> updateUser(int idUser, UserEntity user);
}

class UserRemoteDatasourcesImpl implements IUserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDatasourcesImpl(this.apiClient);
  
  @override
  Future<PagedResultEntity<UserEntity>> getUsers({
    String search = '',
    int page = 0,
    int size = 8,
  }) async{
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page-size': size.toString(),
      };

      if (search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final uri = Uri.http(
        BaseUrl.url,
        '/users',
        queryParams,
      );

      final response = await apiClient.get(uri.toString());

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        final pagedModel = PagedResultModel<UserModel>.fromJson(
          jsonMap,
          (e) => UserModel.fromJson(e),
        );
        final pagedEntity = pagedModel.toEntity((model) => model.toEntity());
        return pagedEntity;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar usuarios! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    }
    catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
  
  @override
  Future<UserEntity> getUserLogged() async{
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/users/logged",
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body)).toEntity();  
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    }on ServerException {
      rethrow; // 👈 mantém a exception original
    }
     catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
  
  @override
  Future<String> updateUser(int idUser, UserEntity user) async{
    try {
      final model = UserModel.fromEntity(user);
      final response = await apiClient.put(
        "${BaseUrl.urlWithHttp}/users/$idUser",
        body: model.toJson()
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 204) {
        return "Atualizado com sucesso!";
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    }on ServerException {
      rethrow; // 👈 mantém a exception original
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
