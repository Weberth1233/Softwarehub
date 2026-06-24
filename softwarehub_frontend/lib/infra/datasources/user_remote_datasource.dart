import 'dart:convert';
import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/user/user_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/paged_result_model.dart';
import '../utils/error_formatter.dart';

abstract class IUserRemoteDataSource
    implements
        IGenericPaginatedList<UserEntity>,
        IGenericPutRemoteDatasource<UserEntity> {
  // Future<PagedResultEntity<UserEntity>> getUsers({
  //   String search,
  //   int page = 0,
  //   int size = 8,
  // });

  Future<UserEntity> getUserLogged();
  // Future<String> updateUser(int idUser, UserEntity user);
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

  // @override
  // Future<PagedResultEntity<UserEntity>> getPaginatedList({
  //   String search = '',
  //   int page = 0,
  //   int size = 8,
  // }) async{
  //   try {
  //     final queryParams = <String, String>{
  //       'page': page.toString(),
  //       'page-size': size.toString(),
  //     };

  //     if (search.isNotEmpty) {
  //       queryParams['search'] = search;
  //     }

  //     final uri = Uri.http(
  //       BaseUrl.url,
  //       '/users',
  //       queryParams,
  //     );

  //     final response = await apiClient.get(uri.toString());

  //     if (response.statusCode == 200) {
  //       final jsonMap = json.decode(response.body);
  //       final pagedModel = PagedResultModel<UserModel>.fromJson(
  //         jsonMap,
  //         (e) => UserModel.fromJson(e),
  //       );
  //       final pagedEntity = pagedModel.toEntity((model) => model.toEntity());
  //       return pagedEntity;
  //     } else {
  //       throw ServerException(
  //         'Erro ${response.statusCode} ao buscar usuarios! - Detalhes: ${response.body}',
  //       );
  //     }
  //   } on ServerException {
  //     rethrow; // 👈 mantém a exception original
  //   }
  //   catch (e) {
  //     throw NetworkException('Erro de conexão com o servidor!');
  //   }
  // }

  @override
  Future<UserEntity> getUserLogged() async {
    final uri = Uri.http(BaseUrl.url, "/users/logged");

    return helper.getById<UserEntity, UserModel>(
      url: uri.toString(),
      fromJson: UserModel.fromJson,
      toEntity: (model) => model.toEntity(),
      errorMessage: "Erro ao buscar dados do usuário logado!"
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

  // @override
  // Future<String> updateUser(int idUser, UserEntity user) async{
  //   try {
  //     final model = UserModel.fromEntity(user);
  //     final response = await apiClient.put(
  //       "${BaseUrl.urlWithHttp}/users/$idUser",
  //       body: model.toJson()
  //     );
  //     print(response.statusCode);
  //     print(response.body);
  //     if (response.statusCode == 204) {
  //       return "Atualizado com sucesso!";
  //     } else {
  //       throw ServerException(
  //         ApiErrorFormatter.formatFromBody(response.body),
  //       );
  //     }
  //   }on ServerException {
  //     rethrow; // 👈 mantém a exception original
  //   } catch (e) {
  //     print(e);
  //     throw NetworkException('Erro de conexão com o servidor!');
  //   }
  // }
}
