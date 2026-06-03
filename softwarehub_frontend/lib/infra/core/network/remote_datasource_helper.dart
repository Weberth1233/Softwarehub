import 'dart:convert';
import '../../../domain/core/errors/exceptions.dart';
import 'api_client.dart';

class RemoteDatasourceHelper {
  final ApiClient apiClient;

  RemoteDatasourceHelper(this.apiClient);

  Future<List<T>> getList<T>({
    required String url,
    required T Function(Map<String, dynamic> json) fromJson,
    String? errorMessage,
    bool authenticated = true,
  }) async {
    try {
      final response = await apiClient.get(
        url,
        authenticated: authenticated,
      );

      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body) as List;

        return decoded
            .map(
              (item) => fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ServerException(
          errorMessage ??
              'Erro ${response.statusCode}! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}