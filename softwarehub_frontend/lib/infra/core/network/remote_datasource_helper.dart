import 'dart:convert';
import 'package:nit_sgpi_frontend/infra/utils/error_formatter.dart';
import '../../../domain/core/errors/exceptions.dart';
import '../../../domain/entities/paged_result_entity.dart';
import '../../models/paged_result_model.dart';
import 'api_client.dart';

class RemoteDatasourceHelper {
  final ApiClient apiClient;

  RemoteDatasourceHelper(this.apiClient);

  dynamic _decodeBody(String body) {
    if (body.isEmpty) return null;
    return json.decode(body);
  }

  bool _isSuccessStatus(int statusCode, List<int> successStatusCodes) {
    return successStatusCodes.contains(statusCode);
  }

  ServerException _buildServerException({
    required int statusCode,
    required String body,
    String? errorMessage,
  }) {
    return ServerException(ApiErrorFormatter.formatFromBody(body));
  }

  Future<PagedResultEntity<TEntity>> getPagedList<TModel, TEntity>({
    required String url,
    required TModel Function(Map<String, dynamic> json) fromJson,
    required TEntity Function(TModel model) toEntity,
    String? errorMessage,
    bool authenticated = true,
    List<int> successStatusCodes = const [200],
  }) async {
    try {
      final response = await apiClient.get(url, authenticated: authenticated);

      if (_isSuccessStatus(response.statusCode, successStatusCodes)) {
        final decoded = _decodeBody(response.body);

        final pagedModel = PagedResultModel<TModel>.fromJson(
          decoded as Map<String, dynamic>,
          (e) => fromJson(e),
        );

        return pagedModel.toEntity(toEntity);
      }

      throw _buildServerException(
        statusCode: response.statusCode,
        body: response.body,
        errorMessage: errorMessage,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  Future<List<T>> getList<T>({
    required String url,
    required T Function(Map<String, dynamic> json) fromJson,
    String? errorMessage,
    bool authenticated = true,
    List<int> successStatusCodes = const [200],
  }) async {
    try {
      final response = await apiClient.get(url, authenticated: authenticated);

      if (_isSuccessStatus(response.statusCode, successStatusCodes)) {
        final decoded = _decodeBody(response.body) as List<dynamic>;

        return decoded
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
      }

      throw _buildServerException(
        statusCode: response.statusCode,
        body: response.body,
        errorMessage: errorMessage,
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  Future<T> getById<T>({
    required String url,
    required T Function(Map<String, dynamic> json) fromJson,
    String? errorMessage,
    bool authenticated = true,
    List<int> successStatusCodes = const [200],
  }) async {
    try {
      final response = await apiClient.get(url, authenticated: authenticated);

      if (_isSuccessStatus(response.statusCode, successStatusCodes)) {
        final decoded = _decodeBody(response.body) as Map<String, dynamic>;

        return fromJson(decoded);
      }

      throw _buildServerException(
        statusCode: response.statusCode,
        body: response.body,
        errorMessage: errorMessage,
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  Future<TResponse> post<TResponse>({
    required String url,
    required dynamic body,
    required TResponse Function(dynamic responseBody) onSuccess,
    String? errorMessage,
    bool authenticated = true,
    List<int> successStatusCodes = const [200, 201],
  }) async {
    try {
      final response = await apiClient.post(
        url,
        body: body,
        authenticated: authenticated,
      );

      if (_isSuccessStatus(response.statusCode, successStatusCodes)) {
        final decoded = _decodeBody(response.body);
        return onSuccess(decoded);
      }

      throw _buildServerException(
        statusCode: response.statusCode,
        body: response.body,
        errorMessage: errorMessage,
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  Future<TResponse> put<TResponse>({
    required String url,
    required dynamic body,
    required TResponse Function(dynamic responseBody, int statusCode) onSuccess,
    String? errorMessage,
    bool authenticated = true,
    List<int> successStatusCodes = const [200, 204],
  }) async {
    try {
      final response = await apiClient.put(
        url,
        body: body,
        authenticated: authenticated,
      );

      if (_isSuccessStatus(response.statusCode, successStatusCodes)) {
        final decoded = _decodeBody(response.body);
        return onSuccess(decoded, response.statusCode);
      }

      throw _buildServerException(
        statusCode: response.statusCode,
        body: response.body,
        errorMessage: errorMessage,
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  Future<TResponse> patch<TResponse>({
    required String url,
    required dynamic body,
    required TResponse Function(dynamic responseBody, int statusCode) onSuccess,
    String? errorMessage,
    bool authenticated = true,
    List<int> successStatusCodes = const [200, 204],
  }) async {
    try {
      final response = await apiClient.patch(
        url,
        body: body,
        authenticated: authenticated,
      );

      if (_isSuccessStatus(response.statusCode, successStatusCodes)) {
        final decoded = _decodeBody(response.body);
        return onSuccess(decoded, response.statusCode);
      }

      throw _buildServerException(
        statusCode: response.statusCode,
        body: response.body,
        errorMessage: errorMessage,
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  Future<TResponse> delete<TResponse>({
    required String url,
    required TResponse Function(dynamic responseBody, int statusCode) onSuccess,
    String? errorMessage,
    bool authenticated = true,
    List<int> successStatusCodes = const [200, 204],
    Map<int, TResponse Function(String body)>? statusCodeHandlers,
  }) async {
    try {
      final response = await apiClient.delete(
        url,
        authenticated: authenticated,
      );

      if (_isSuccessStatus(response.statusCode, successStatusCodes)) {
        final decoded = _decodeBody(response.body);
        return onSuccess(decoded, response.statusCode);
      }

      final handler = statusCodeHandlers?[response.statusCode];

      if (handler != null) {
        return handler(response.body);
      }

      throw _buildServerException(
        statusCode: response.statusCode,
        body: response.body,
        errorMessage: errorMessage,
      );
    } on ServerException {
      rethrow;
    } catch (_) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
