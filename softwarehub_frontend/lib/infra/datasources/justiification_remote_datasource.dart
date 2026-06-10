import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import 'package:nit_sgpi_frontend/infra/models/justification/justification_request_model.dart';
import '../../domain/entities/justification/justification_attachment_file_entity.dart';
import '../core/network/api_client.dart';
import '../utils/error_formatter.dart';

abstract class IJustificationRemoteDataSource {
  Future<String> postJustification(JustificationRequestEntity justification);
  Future<JustificationAttachmentFileEntity> getAttachmentFile(int attachmentId);

  Future<String> deleteJustification(int idJustification);
  // Future<String> putJustificattion(
  //   int idJustification,
  //   JustificationRequestEntity justification,
  // );
}

class JustificationRemoteDatasourceImpl
    implements IJustificationRemoteDataSource {
  final ApiClient apiClient;

  JustificationRemoteDatasourceImpl(this.apiClient);

  @override
  @override
  Future<String> postJustification(
    JustificationRequestEntity justification,
  ) async {
    try {
      final model = JustificationRequestModel.fromEntity(justification);

      final response = await apiClient.multipartPost(
        "${BaseUrl.urlWithHttp}/justification",
        fields: {
          "processId": model.processId.toString(),
          "reason": model.reason,
        },
        filePath: model.filePath,
        fileBytes: model.fileBytes,
        fileName: model.fileName,
        fieldName: "file",
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 201) {
        return "Cadastrado com sucesso!";
      } else if (response.statusCode == 422) {
        return response.body;
      } else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  @override
  Future<String> deleteJustification(int idJustification) async {
    try {
      final response = await apiClient.delete(
        "${BaseUrl.urlWithHttp}/justification/$idJustification",
      );
      if (response.statusCode == 204) {
        return "Removido com sucesso!";
      } else if (response.statusCode == 404) {
        return "Não encontrou justificativa na base de dados!";
      } else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    } catch (e) {
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  @override
  Future<JustificationAttachmentFileEntity> getAttachmentFile(
    int attachmentId,
  ) async {
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/justification/attachments/$attachmentId/file",
      );

      print('STATUS: ${response.statusCode}');
      print('CONTENT-TYPE: ${response.headers['content-type']}');

      if (response.statusCode == 200) {
        final contentType =
            response.headers['content-type'] ?? 'application/octet-stream';

        final contentDisposition = response.headers['content-disposition'];
        final fileName = _extractFileName(contentDisposition);

        return JustificationAttachmentFileEntity(
          bytes: response.bodyBytes,
          contentType: contentType,
          fileName: fileName,
        );
      } else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }

  String? _extractFileName(String? contentDisposition) {
    if (contentDisposition == null) return null;

    final regex = RegExp(r'filename="?([^"]+)"?');
    final match = regex.firstMatch(contentDisposition);

    return match?.group(1);
  }
  
  // @override
  // Future<String> putJustificattion(
  //   int idJustification,
  //   JustificationRequestEntity justification,
  // ) async {
  //   try {
  //     final model = JustificationRequestModel.fromEntity(justification);

  //     final response = await apiClient.put(
  //       "${BaseUrl.urlWithHttp}/justification/$idJustification",
  //       body: model.toJson(),
  //     );

  //     if (response.statusCode == 204) {
  //       return "Atualizo com sucesso!";
  //     } else if (response.statusCode == 422) {
  //       return response.body;
  //     } else {
  //       throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
  //     }
  //   } on ServerException {
  //     rethrow; // 👈 mantém a exception original
  //   } catch (e) {
  //     print(e);
  //     throw NetworkException("Erro de conexão com o servidor!");
  //   }
  // }
}
