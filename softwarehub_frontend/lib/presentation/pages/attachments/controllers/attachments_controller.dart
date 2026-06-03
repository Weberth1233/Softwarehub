import 'dart:typed_data'; // <--- Necessário para Uint8List
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/attachments/get_attachments.dart';
import 'package:nit_sgpi_frontend/domain/usecases/attachments/upload_file.dart';
import 'package:nit_sgpi_frontend/domain/usecases/attachments/open_attachment.dart';
import '../../../../domain/core/errors/failures.dart';

class AttachmentController extends GetxController {
  final GetAttachments getAttachments;
  final OpenAttachmentUseCase openAttachment;
  final UploadFile uploadFile;

  AttachmentController(this.openAttachment, this.getAttachments, this.uploadFile);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Variáveis para controle de upload
  final RxBool isLoadingUploadFile = false.obs;
  final RxString messageUpload = ''.obs;

  final RxList<AttachmentEntity> attachmentList = <AttachmentEntity>[].obs;

  /// Variável auxiliar para saber qual processo estamos visualizando.
  int? currentProcessId;

  // ===========================================================================
  // 1. Lógica de Selecionar Arquivo (Híbrida: Web & Mobile)
  // ===========================================================================
  Future<void> pickAndUpload({required int attachmentId}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
        withData: true, 
      );

      if (result != null) {
        PlatformFile pFile = result.files.single;

        await _upload(
          attachmentId: attachmentId,
          path: pFile.path,        // Útil para Mobile (Android/iOS)
          bytes: pFile.bytes,      // Útil para Web
          fileName: pFile.name,    // Obrigatório para Web
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erro",
        "Erro ao selecionar arquivo: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ===========================================================================
  // 2. Upload (Agora aceita Path ou Bytes, não mais File dart:io)
  // ===========================================================================
  Future<void> _upload({
    required int attachmentId, 
    String? path, 
    Uint8List? bytes, 
    required String fileName
  }) async {
    isLoadingUploadFile.value = true;

    final result = await uploadFile(
      id: attachmentId,
      fileName: fileName,
      fileBytes: bytes,
      filePath: path,
    );

    result.fold(
      (Failure failure) {
        messageUpload.value = failure.message;
        Get.snackbar(
          "Erro no Upload",
          failure.message,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      (success) async {
        messageUpload.value = success;
        
        Get.snackbar(
          "Sucesso",
          "Arquivo enviado com sucesso!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Recarrega a lista para mostrar o novo anexo
        if (currentProcessId != null) {
          await attachments(currentProcessId!);
        }
      },
    );

    isLoadingUploadFile.value = false;
  }

  // ===========================================================================
  // 3. Listagem
  // ===========================================================================
  Future<void> attachments(int idProcess) async {
    currentProcessId = idProcess; 

    if (isLoading.value) return;

    isLoading.value = true;

    final result = await getAttachments(idProcess);

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
        attachmentList.clear();
      },
      (list) {
        attachmentList.assignAll(list);
      },
    );
    isLoading.value = false;
  }

  // ===========================================================================
  // 4. Abrir Anexo
  // ===========================================================================
  Future<void> open(int id,{bool signed = false}) async {
    try {
      await openAttachment(id,signed: signed);
    } catch (e) {
      Get.snackbar("Erro", "Não foi possível abrir o documento");
    }
  }
}