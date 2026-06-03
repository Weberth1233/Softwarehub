import 'dart:convert';
import 'package:flutter/foundation.dart'; 
import 'package:web/web.dart' as web; 
import 'dart:js_interop'; 
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/infra/models/attachment_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';

abstract class IAttachmentDatasource {
  Future<void> openDocument(int id, {bool signed = false});
  Future<List<AttachmentEntity>> getAttachments(int idProcess);

  Future<String> uploadDocument({
    required int id, 
    String? filePath,       // Para Mobile
    Uint8List? fileBytes,   // Para Web
    required String fileName // Obrigatório para Web
  });
}

class AttachmentDataSourceImpl implements IAttachmentDatasource {
  final ApiClient apiClient;

  AttachmentDataSourceImpl(this.apiClient);

  @override
  Future<void> openDocument(int id, {bool signed = false}) async {
  String url = "";
    if(signed){
     url = "${BaseUrl.urlWithHttp}/attachments/download/signed/$id";
    } else{
      url = "${BaseUrl.urlWithHttp}/attachments/download/template/$id";
    }
    final response = await apiClient.get(url);

    if (response.statusCode != 200) {
      throw ServerException("Erro ao baixar documento: ${response.statusCode}");
    }

    if (kIsWeb) {
      try {
        final arrayBuffer = response.bodyBytes.toJS;
        
        final blob = web.Blob(
          [arrayBuffer].toJS, 
          web.BlobPropertyBag(type: 'application/pdf')
        );

        final blobUrl = web.URL.createObjectURL(blob);

        final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
        anchor.href = blobUrl;
        anchor.download = 'documento_sgpi_$id.pdf'; // Nome sugerido para salvar
        anchor.style.display = 'none';

        web.document.body?.append(anchor);
        anchor.click();
        anchor.remove();

        Future.delayed(const Duration(seconds: 2), () {
          web.URL.revokeObjectURL(blobUrl);
        });

      } catch (e) {
        throw Exception("Erro ao processar download na Web: $e");
      }
    } else {
      throw UnimplementedError("Visualização direta no Mobile ainda não implementada neste trecho.");
    }
  }

  @override
  Future<List<AttachmentEntity>> getAttachments(int idProcess) async {
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/attachments/process/$idProcess",
      );

      if (response.statusCode == 200) {
        final List decoded = json.decode(response.body) as List;

        return decoded
            .map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList();
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar anexos! - Detalhes: ${response.body}',
        );
      }
    }on ServerException {
      rethrow; // 👈 mantém a exception original
    }
     catch (e) {
      // Se não for ServerException, assume erro de rede
      if (e is ServerException) rethrow;
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }

  @override
  Future<String> uploadDocument({
    required int id, 
    String? filePath, 
    Uint8List? fileBytes, 
    required String fileName
  }) async {
    try {
      final response = await apiClient.upload(
        "${BaseUrl.urlWithHttp}/attachments/upload/$id",
        filePath: filePath,
        fileBytes: fileBytes,
        fileName: fileName,
        fieldName: 'file',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao enviar arquivo! - Detalhes: ${response.body}',
        );
      }
    }on ServerException {
      rethrow;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Erro de conexão ao tentar enviar o arquivo.');
    }
  }
}