import 'dart:convert';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/entities/justification/justification_attachment_file_entity.dart';
import '../../domain/entities/justification/justification_request_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/justification/justification_attachment_file_model.dart';
import '../models/justification/justification_request_model.dart';
import '../utils/error_formatter.dart';

abstract class IJustificationRemoteDataSource
    implements
        IGenericPostRemoteDatasource<JustificationRequestEntity, String>,
        IGenericPutRemoteDatasource<JustificationRequestEntity>,
        IGenericGetByIdRemoteDatasource<JustificationAttachmentFileEntity>,
        IGenericDeleteRemoteDatasource {}

class JustificationRemoteDatasourceImpl
    implements IJustificationRemoteDataSource {
  final ApiClient apiClient;
  final RemoteDatasourceHelper helper;

  JustificationRemoteDatasourceImpl(this.apiClient)
      : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<String> post(JustificationRequestEntity entity) async {
    final uri = Uri.http(BaseUrl.url, "/justification");
    final model = JustificationRequestModel.fromEntity(entity);
    
    try {
      final response = await apiClient.multipartRequest(
        uri.toString(),
        method: "POST",
        fields: {
          "processId": model.processId.toString(),
          "reason": model.reason,
        },
        filePath: model.filePath,
        fileBytes: model.fileBytes,
        fileName: model.fileName,
        fieldName: "file",
      );

      return _handleSuccessMessage(
        statusCode: response.statusCode,
        body: response.body,
        successStatusCodes: const [200, 201, 204],
        defaultMessage: "Justificativa cadastrada com sucesso!",
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  @override
  Future<String> put(int id, JustificationRequestEntity entity) async {
    final uri = Uri.http(BaseUrl.url, "/justification/$id");
    final model = JustificationRequestModel.fromEntity(entity);

    try {
      final response = await apiClient.multipartRequest(
        uri.toString(),
        method: "PUT",
        fields: {
          "processId": model.processId.toString(),
          "reason": model.reason,
        },
        filePath: model.filePath,
        fileBytes: model.fileBytes,
        fileName: model.fileName,
        fieldName: "file",
      );

      return _handleSuccessMessage(
        statusCode: response.statusCode,
        body: response.body,
        successStatusCodes: const [200, 201, 204],
        defaultMessage: "Justificativa atualizada com sucesso!",
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  @override
  Future<String> delete(int id) {
    final uri = Uri.http(BaseUrl.url, "/justification/$id");

    return helper.delete(
      url: uri.toString(),
      onSuccess: (responseBody, statusCode) {
        if (statusCode == 204 || responseBody == null) {
          return "Registro excluído com sucesso!";
        }

        if (responseBody is Map<String, dynamic>) {
          return responseBody["message"]?.toString() ??
              "Registro excluído com sucesso!";
        }

        return responseBody.toString();
      },
    );
  }

  @override
  Future<JustificationAttachmentFileEntity> getById(int id) async {
    final uri = Uri.http(
      BaseUrl.url,
      "/justification/attachments/$id/file",
    );

    try {
      final response = await apiClient.get(uri.toString());

      if (response.statusCode == 200) {
        final contentType = _normalizeContentType(
          response.headers["content-type"],
        );

        final contentDisposition = response.headers["content-disposition"];
        final fileName = _extractFileName(contentDisposition);

        final model = JustificationAttachmentFileModel(
          bytes: response.bodyBytes,
          contentType: contentType,
          fileName: fileName,
        );

        return model.toEntity();
      }

      throw ServerException(
        ApiErrorFormatter.formatFromBody(response.body),
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  String _handleSuccessMessage({
    required int statusCode,
    required String body,
    required List<int> successStatusCodes,
    required String defaultMessage,
  }) {
    if (!successStatusCodes.contains(statusCode)) {
      throw ServerException(ApiErrorFormatter.formatFromBody(body));
    }

    if (statusCode == 204 || body.trim().isEmpty) {
      return defaultMessage;
    }

    try {
      final decodedBody = json.decode(body);

      if (decodedBody is Map<String, dynamic>) {
        return decodedBody["message"]?.toString() ?? defaultMessage;
      }

      if (decodedBody is String && decodedBody.trim().isNotEmpty) {
        return decodedBody;
      }
    } catch (_) {
      final message = body.trim();

      if (message.isNotEmpty) {
        return message;
      }
    }

    return defaultMessage;
  }

  String _normalizeContentType(String? contentType) {
    if (contentType == null || contentType.trim().isEmpty) {
      return "application/octet-stream";
    }

    return contentType.split(";").first.trim();
  }

  String? _extractFileName(String? contentDisposition) {
    if (contentDisposition == null) return null;

    final regex = RegExp(r'filename="?([^"]+)"?');
    final match = regex.firstMatch(contentDisposition);

    return match?.group(1);
  }
}