import '../../domain/entities/paged_result_entity.dart';
import '../../domain/entities/process/process_request_entity.dart';
import '../../domain/entities/process/process_response_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/process/proces_status_count_model.dart';
import '../models/process/process_request_model.dart';
import '../models/process/process_response_model.dart';

abstract class IProcessRemoteDataSource
    implements
        IGenericPaginatedList<ProcessResponseEntity>,
        IGenericPutRemoteDatasource<ProcessRequestEntity>,
        IGenericPostRemoteDatasource<ProcessRequestEntity, int>,
        IGenericDeleteRemoteDatasource,
        IGenericGetByIdRemoteDatasource<ProcessResponseEntity> {
  Future<List<ProcessStatusCountModel>> getProcessesStatusCount();
  Future<String> updateStatusProcess(int processId, String newStatus);
  Future<String> processClassification(
    int processId,
    List<int> applicationFields, {
    bool isEdit = false,
  });
}

class ProcessRemoteDataSourceImpl implements IProcessRemoteDataSource {
  final RemoteDatasourceHelper helper;

  ProcessRemoteDataSourceImpl(ApiClient apiClient)
    : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<List<ProcessStatusCountModel>> getProcessesStatusCount() async {
    final uri = Uri.http(BaseUrl.url, "/process/status/amount");

    return helper.getList<ProcessStatusCountModel>(
      url: uri.toString(),
      fromJson: ProcessStatusCountModel.fromJson,
      errorMessage: "Erro ao buscar dados de status dos processo!",
    );
  }

  @override
  Future<String> updateStatusProcess(int processId, String newStatus) async {
    final uri = Uri.http(BaseUrl.url, "/process/$processId/status");
    return helper.patch(
      url: uri.toString(),
      body: {"status": newStatus},
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

  @override
  Future<String> processClassification(
    int processId,
    List<int> applicationFields, {
    bool isEdit = false,
  }) async {
    final uri = Uri.http(BaseUrl.url, "/process/$processId/classification");

    final body = {'applicationFields': applicationFields};

    if (isEdit) {
      return helper.put<String>(
        url: uri.toString(),
        body: body,
        successStatusCodes: const [200, 201, 204],
        onSuccess: (responseBody, statusCode) {
          if (statusCode == 204 || responseBody == null) {
            return 'Classificação atualizada com sucesso!';
          }

          if (responseBody is Map<String, dynamic>) {
            return responseBody['message']?.toString() ??
                'Classificação atualizada com sucesso!';
          }

          final message = responseBody.toString().trim();

          if (message.isNotEmpty) {
            return message;
          }

          return 'Classificação atualizada com sucesso!';
        },
      );
    }

    return helper.post<String>(
      url: uri.toString(),
      body: body,
      successStatusCodes: const [200, 201, 204],
      onSuccess: (responseBody) {
        if (responseBody == null) {
          return 'Processo classificado com sucesso!';
        }

        if (responseBody is Map<String, dynamic>) {
          return responseBody['message']?.toString() ??
              'Processo classificado com sucesso!';
        }

        final message = responseBody.toString().trim();

        if (message.isNotEmpty) {
          return message;
        }

        return 'Processo classificado com sucesso!';
      },
    );
  }

  @override
  Future<String> delete(int id) {
    final uri = Uri.http(BaseUrl.url, "/process/$id");
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
  Future<ProcessResponseEntity> getById(int id) {
    final uri = Uri.http(BaseUrl.url, "/process/$id");

    return helper.getById<ProcessResponseEntity, ProcessResponseModel>(
      url: uri.toString(),
      fromJson: ProcessResponseModel.fromJson,
      toEntity: (model) => model.toEntity(),
      errorMessage: "Erro ao buscar dados do processo!",
    );
  }

  @override
  Future<PagedResultEntity<ProcessResponseEntity>> getPaginatedList(
    Map<String, String> values,
  ) {
    final uri = Uri.http(BaseUrl.url, "/process/user/processes", values);
    return helper.getPagedList<ProcessResponseModel, ProcessResponseEntity>(
      url: uri.toString(),
      fromJson: ProcessResponseModel.fromJson,
      toEntity: (model) => model.toEntity(),
      errorMessage: "Erro ao buscar os processos!",
    );
  }

  @override
  Future<int> post(ProcessRequestEntity entity) {
    final uri = Uri.http(BaseUrl.url, "/process");
    final model = ProcessRequestModel.fromEntity(entity);

    return helper.post<int>(
      url: uri.toString(),
      body: model.toJson(),
      onSuccess: (responseBody) {
        return responseBody["id"];
      },
    );
  }

  @override
  Future<String> put(int id, ProcessRequestEntity entity) {
    final uri = Uri.http(BaseUrl.url, "/process/$id");
    final model = ProcessRequestModel.fromEntity(entity);

    return helper.put(
      url: uri.toString(),
      body: model.toJson(),
      onSuccess: (responseBody, statusCode) {
        if (statusCode == 204 || responseBody == null) {
          return 'Processo atualizado com sucesso!';
        }
        if (responseBody is Map<String, dynamic>) {
          return responseBody['message']?.toString() ??
              'Processo atualizado com sucesso!';
        }
        return responseBody.toString();
      },
    );
  }
}
