import 'dart:convert';

import 'package:nit_sgpi_frontend/domain/entities/paged_result_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_response_entity.dart';
import 'package:nit_sgpi_frontend/infra/core/network/api_client.dart';
import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import 'package:nit_sgpi_frontend/infra/models/process/proces_status_count_model.dart';
import 'package:nit_sgpi_frontend/infra/models/process/process_request_model.dart';
import 'package:nit_sgpi_frontend/infra/utils/error_formatter.dart';

import '../../domain/core/errors/exceptions.dart';
import '../models/paged_result_model.dart';
import '../models/process/process_response_model.dart';

abstract class IProcessRemoteDataSource {
  Future<PagedResultEntity<ProcessResponseEntity>> getProcesses({
    String title = "",
    String statusProcess = "",
    int page = 0,
    int size = 10,
  });
  Future<List<ProcessStatusCountModel>> getProcessesStatusCount();
  Future<int> postProcess(ProcessRequestEntity entity);
  Future<String> putProcess(int processId, ProcessRequestEntity entity);
  Future<String> deleteProcess(int idProcess);
  Future<ProcessResponseEntity> getProcessById(int processId);
  Future<String> updateStatusProcess(int processId, String newStatus);
  Future<String> processClassification(int processId, List<int> applicationFields);
}

class ProcessRemoteDataSourceImpl implements IProcessRemoteDataSource {
  final ApiClient apiClient;

  ProcessRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PagedResultEntity<ProcessResponseEntity>> getProcesses({
    String title = "",
    String statusProcess = "",
    int page = 0,
    int size = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page-size': size.toString(),
      };

      if (title.isNotEmpty) {
        queryParams['title'] = title;
      }

      if (statusProcess.isNotEmpty) {
        queryParams['status-process'] = statusProcess;
      }

      final uri = Uri.http(BaseUrl.url, '/process/user/processes', queryParams);

      final response = await apiClient.get(uri.toString());

      if (response.statusCode == 200) {
        final jsonMap = json.decode(response.body);
        final pagedModel = PagedResultModel<ProcessResponseModel>.fromJson(
          jsonMap,
          (e) => ProcessResponseModel.fromJson(e),
        );
        final pagedEntity = pagedModel.toEntity((model) => model.toEntity());

        return pagedEntity;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  @override
  Future<List<ProcessStatusCountModel>> getProcessesStatusCount() async {
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/process/status/amount",
      );

      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body) as List;

        return decoded
            .map(
              (e) =>
                  ProcessStatusCountModel.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  @override
  Future<int> postProcess(ProcessRequestEntity entity) async {
    try {
      final model = ProcessRequestModel.fromEntity(entity);

      final response = await apiClient.post(
        "${BaseUrl.urlWithHttp}/process",
        body: model.toJson(),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final int id = data["id"];

        return id;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} erro no cadastro! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  @override
  Future<ProcessResponseEntity> getProcessById(int processId) async {
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/process/$processId",
      );
      if (response.statusCode == 200) {
        ProcessResponseEntity processRequestEntity =
            ProcessResponseModel.fromJson(
              json.decode(response.body),
            ).toEntity();
        return processRequestEntity;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar processos! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  @override
  Future<String> deleteProcess(int idProcess) async {
    try {
      final response = await apiClient.delete(
        "${BaseUrl.urlWithHttp}/process/$idProcess",
      );
      if (response.statusCode == 204) {
        return "Removido com sucesso!";
      } else if (response.statusCode == 404) {
        return "Não encontrou justificativa na base de dados!";
      } else {
        throw ServerException(
          'Erro ${response.statusCode} erro na deleção! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  @override
  Future<String> updateStatusProcess(int processId, String newStatus) async {
    try {
      final response = await apiClient.patch(
        "${BaseUrl.urlWithHttp}/process/$processId/status",
        body: {"status": newStatus},
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return "Status atualizado com sucesso!";
      } else {
        throw ServerException('Erro ${response.statusCode}: ${response.body}');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro de conexão! $e');
    }
  }

  @override
  Future<String> putProcess(int processId, ProcessRequestEntity entity) async {
    try {
      final model = ProcessRequestModel.fromEntity(entity);

      final response = await apiClient.put(
        "${BaseUrl.urlWithHttp}/process/$processId",
        body: model.toJson(),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 204) {
        return "Atualizado com sucesso!";
      } else if (response.statusCode == 422) {
        return response.body;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} erro no cadastro! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  @override
  Future<String> processClassification(int processId, List<int> applicationFields) async {
    try {
      final response = await apiClient.patch(
        "${BaseUrl.urlWithHttp}/process/$processId/classification",
        body: {'applicationFields': applicationFields},
      );
      if (response.statusCode == 204) {
        return 'Processo classificado com sucesso!';
      } else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
