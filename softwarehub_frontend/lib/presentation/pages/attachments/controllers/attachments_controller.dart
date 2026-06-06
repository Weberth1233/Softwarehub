import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/attachment_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/attachments/get_attachments.dart';
import 'package:nit_sgpi_frontend/domain/usecases/attachments/upload_file.dart';
import 'package:nit_sgpi_frontend/domain/usecases/attachments/open_attachment.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/app_toast.dart';
import '../../../../domain/core/errors/failures.dart';

class AttachmentController extends GetxController {
  final GetAttachments getAttachments;
  final OpenAttachmentUseCase openAttachment;
  final UploadFile uploadFile;

  AttachmentController(this.openAttachment, this.getAttachments, this.uploadFile);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isLoadingUploadFile = false.obs;
  final RxString messageUpload = ''.obs;

  final RxList<AttachmentEntity> attachmentList = <AttachmentEntity>[].obs;

  int? currentProcessId;


  @override
  void onReady() {
    super.onReady();
    _loadAttachments();
  }

  void _loadAttachments() {
    // 1. Tenta pegar o ID direto da URL (:id)
    String? idStr = Get.parameters['id'];
    int processId = 0;

    if (idStr != null && idStr.isNotEmpty) {
      processId = int.tryParse(idStr) ?? 0;
    } 
    // 2. Fallback para os argumentos
    else if (Get.arguments is int) {
      processId = Get.arguments as int;
    }

    // 3. Chama a API
    if (processId != 0) {
      attachments(processId);
    } else {
      debugPrint("Erro: processId não foi encontrado na rota e nem nos argumentos.");
      // AppToast.error("ID do processo não identificado.");
    }
  }
  
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
      AppToast.error("Erro ao selecionar arquivo: $e");
      
    }
  }

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
        AppToast.error("Erro no Upload - ${failure.message}");
      },
      (success) async {
        messageUpload.value = success;
        AppToast.success("Sucesso - Arquivo enviado com sucesso!");
        // Recarrega a lista para mostrar o novo anexo
        if (currentProcessId != null) {
          await attachments(currentProcessId!);
        }
      },
    );

    isLoadingUploadFile.value = false;
  }

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

  Future<void> open(int id,{bool signed = false}) async {
    try {
      await openAttachment(id,signed: signed);
    } catch (e) {
      AppToast.error("Erro - Não foi possível abrir o documento");
    }
  }
}