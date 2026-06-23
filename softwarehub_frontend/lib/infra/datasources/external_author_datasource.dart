import '../../domain/entities/external_author/external_author_entity.dart';
import '../../domain/entities/paged_result_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/external_author_model.dart';

abstract class IExternalAuthorRemoteDataSource
    implements
        IGenericPaginatedList<ExternalAuthorEntity>,
        IGenericPostRemoteDatasource<ExternalAuthorEntity>,
        IGenericPutRemoteDatasource<ExternalAuthorEntity>,
        IGenericDeleteRemoteDatasource {
  // Future<PagedResultEntity<ExternalAuthorEntity>> getExternalAuthors({
  //   String search = '',
  //   int page = 0,
  //   int size = 10,
  // });
  // Future<String> postExternalAuthor(ExternalAuthorEntity entity);
  // Future<String> deleteExternalAuthor(int id);
  // Future<String> putExternalAuthor(int id, ExternalAuthorEntity entity);
}

class ExternalAuthorDataSource implements IExternalAuthorRemoteDataSource {
  final RemoteDatasourceHelper helper;

  ExternalAuthorDataSource(ApiClient apiClient)
    : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<PagedResultEntity<ExternalAuthorEntity>> getPaginatedList(
    Map<String, String> values,
  ) {
    final uri = Uri.http(
      BaseUrl.url,
      "/external_author/user/external_authors",
      values,
    );
    return helper.getPagedList<ExternalAuthorModel, ExternalAuthorEntity>(
      url: uri.toString(),
      fromJson: ExternalAuthorModel.fromJson,
      toEntity: (model) => model.toEntity(),
      errorMessage: "Erro ao buscar dados de usuários externos!",
    );
  }

  @override
  Future<String> delete(int id) {
    final uri = Uri.http(BaseUrl.url, "/external_author/$id");
    return helper.delete(
      url: uri.toString(),
      onSuccess: (responseBody, statusCode) {
        if (statusCode == 204 || responseBody == null) {
          return 'Registro excluído com sucesso!';
        }

        if (responseBody is Map<String, dynamic>) {
          return responseBody['message']?.toString() ??
              'Registro excluído com sucesso!';
        }
        return responseBody.toString();
      },
    );
  }

  @override
  Future<String> post(ExternalAuthorEntity entity) {
    final uri = Uri.http(BaseUrl.url, "/external_author");
    final model = ExternalAuthorModel.fromEntity(entity);

    return helper.post(
      url: uri.toString(),
      body: model.toJson(),
      onSuccess: (responseBody) {
        if (responseBody is Map<String, dynamic>) {
          return responseBody['message']?.toString() ??
              'Usuário externo cadastrado com sucesso!';
        }
        if (responseBody is String && responseBody.trim().isNotEmpty) {
          return responseBody;
        }
        return 'Usuário externo cadastrado com sucesso!';
      },
    );
  }

  @override
  Future<String> put(int id, ExternalAuthorEntity entity) {
    final uri = Uri.http(BaseUrl.url, "/external_author/$id");
    final model = ExternalAuthorModel.fromEntity(entity);

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
  // Future<PagedResultEntity<ExternalAuthorEntity>> getPaginatedList({String search = '', int page = 0, int size = 10}) async{
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
  //       '/external_author/user/external_authors',
  //       queryParams,
  //     );

  //     final response = await apiClient.get(uri.toString());

  //     if (response.statusCode == 200) {
  //       final jsonMap = json.decode(response.body);
  //       final pagedModel = PagedResultModel<ExternalAuthorModel>.fromJson(
  //         jsonMap,
  //         (e) => ExternalAuthorModel.fromJson(e),
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

  // @override
  // Future<String> postExternalAuthor(ExternalAuthorEntity entity) async{
  //   try {
  //     final model = ExternalAuthorModel.fromEntity(entity);

  //     final response = await apiClient.post(
  //       "${BaseUrl.urlWithHttp}/external_author",
  //       body: model.toJson(),
  //     );

  //     print('STATUS: ${response.statusCode}');
  //     print('BODY: ${response.body}');

  //     if (response.statusCode == 201) {
  //       return "Cadastrado com sucesso!";
  //     } else if (response.statusCode == 422) {
  //       // 👇 transforma o JSON de erro em string bonita
  //       return response.body;
  //     } else {
  //       throw ServerException(
  //         'Erro ${response.statusCode} erro no cadastro! - Detalhes: ${response.body}',
  //       );
  //     }
  //   }on ServerException {
  //     rethrow; // 👈 mantém a exception original
  //   } catch (e) {
  //     print(e);
  //     throw NetworkException('Erro de conexão com o servidor!');
  //   }
  // }

  // @override
  // Future<String> deleteExternalAuthor(int id) async{
  //   try{
  //     final response = await apiClient.delete("${BaseUrl.urlWithHttp}/external_author/$id");
  //     if(response.statusCode == 204){
  //       return "Removido com sucesso!";
  //     }else if(response.statusCode == 404){
  //       return "Não encontrou Usuário externo na base de dados!";
  //     }else {
  //       throw ServerException(
  //         'Erro ${response.statusCode} erro na deleção! - Detalhes: ${response.body}',
  //       );
  //     }
  //   }on ServerException {
  //     rethrow; // 👈 mantém a exception original
  //   }
  //   catch(e){
  //     print(e);
  //     throw NetworkException("Erro de conexão com o servidor!");
  //   }
  // }

  // @override
  // Future<String> putExternalAuthor(int id, ExternalAuthorEntity entity) async{
  //   try{
  //     final model = ExternalAuthorModel.fromEntity(entity);

  //     final response = await apiClient.put("${BaseUrl.urlWithHttp}/external_author/$id",
  //     body: model.toJson(),
  //     );

  //     if (response.statusCode == 204) {
  //       return "Atualizo com sucesso!";
  //     } else if (response.statusCode == 422) {
  //       return response.body;
  //     } else {
  //       throw ServerException(
  //         'Erro ${response.statusCode} erro no cadastro! - Detalhes: ${response.body}',
  //       );
  //     }
  //   }on ServerException {
  //     rethrow; // 👈 mantém a exception original
  //   }
  //   catch(e){
  //     print(e);
  //     throw NetworkException("Erro de conexão com o servidor!");
  //   }
  // }
}
