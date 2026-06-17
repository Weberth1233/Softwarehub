import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:universal_html/universal_html.dart' as html;

import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../domain/usecases/justification/delete_justification.dart';
import '../../../../domain/usecases/justification/get_attachment_file.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../../domain/usecases/process/process_classification.dart';
import '../../../../domain/usecases/process/update_status_process.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../shared/utils/app_toast.dart';

class ProcessDetailController extends GetxController {
  final GetProcessById _getProcessById;
  final DeleteJustification _deleteJustification;
  final UpdateStatusProcess _updateStatusProcess;
  final ProcessClassification _processClassification;
  final GetAttachmentFile _attachmentFile;
  final AuthLocalDataSource _authLocal;

  ProcessDetailController(
    this._getProcessById,
    this._authLocal,
    this._deleteJustification,
    this._updateStatusProcess,
    this._processClassification,
    this._attachmentFile,
  );

  final RxBool isLoading = false.obs;
  final RxBool isLoadingAttachment = false.obs;

  final RxString errorMessage = ''.obs;
  final RxString message = ''.obs;

  final Rxn<ProcessResponseEntity> process = Rxn<ProcessResponseEntity>();

  final RxString userRole = ''.obs;

  final Rxn<Uint8List> attachmentBytes = Rxn<Uint8List>();
  final RxString attachmentContentType = ''.obs;
  final RxnString attachmentFileName = RxnString();

  bool get isAdmin => userRole.value == 'ADMIN';

  bool get hasAttachmentLoaded => attachmentBytes.value != null;

  bool get isAttachmentImage =>
      attachmentContentType.value.startsWith('image/');

  bool get isAttachmentPdf => attachmentContentType.value == 'application/pdf';

  @override
  void onInit() {
    super.onInit();
    _checkRole();
    _loadProcessId();
  }

  @override
  void onClose() {
    process.value = null;
    attachmentBytes.value = null;
    attachmentContentType.value = '';
    attachmentFileName.value = null;
    super.onClose();
  }

  Future<void> _checkRole() async {
    final role = await _authLocal.getRole();
    if (role != null) {
      userRole.value = role;
    }
  }

  void _loadProcessId() {
    String? idStr = Get.parameters['id'];
    var argId = Get.arguments;

    int? finalId;

    if (idStr != null && idStr.isNotEmpty) {
      finalId = int.tryParse(idStr);
    } else if (argId != null && argId is int) {
      finalId = argId;
    }

    if (finalId != null) {
      fetchProcess(finalId);
    } else {
      errorMessage.value = "ID do processo não encontrado.";
      AppToast.error("Erro - Não foi possível identificar o ID do processo.");
    }
  }
  

  Future<void> fetchProcess(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getProcessById(id);

    result.fold(
      (Failure failure) {
        isLoading.value = false;
        errorMessage.value = failure.message;
        process.value = null;

        AppToast.error("Falha ao carregar processo: ${failure.message}");
      },
      (ProcessResponseEntity success) {
        isLoading.value = false;
        process.value = success;
      },
    );
  }

  Future<void> getAttachmentFile(int attachmentId) async {
    try {
      isLoadingAttachment.value = true;
      message.value = '';

      final result = await _attachmentFile(attachmentId);

      result.fold(
        (Failure failure) {
          message.value = failure.message;
          AppToast.error("Erro - ${failure.message}");
        },
        (file) {
          attachmentBytes.value = Uint8List.fromList(file.bytes);
          attachmentContentType.value = file.contentType;
          attachmentFileName.value = file.fileName;

          AppToast.success("Arquivo carregado com sucesso!");
        },
      );
    } catch (e) {
      AppToast.error(
        "Erro inesperado - Ocorreu um erro ao tentar carregar o arquivo.",
      );
    } finally {
      isLoadingAttachment.value = false;
    }
  }

  void openPdfInNewTab() {
    final bytes = attachmentBytes.value;

    if (bytes == null || bytes.isEmpty) {
      AppToast.error("Arquivo não carregado.");
      return;
    }

    final blob = html.Blob([bytes], 'application/pdf');

    final url = html.Url.createObjectUrlFromBlob(blob);

    html.window.open(url, '_blank');

    Future.delayed(const Duration(seconds: 2), () {
      html.Url.revokeObjectUrl(url);
    });
  }

  void clearAttachmentFile() {
    attachmentBytes.value = null;
    attachmentContentType.value = '';
    attachmentFileName.value = null;
  }

  Future<void> classifyProcess(int processId, List<int> niceClassCode, {
    bool isEdit = false,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      message.value = '';

      final result = await _processClassification(processId, niceClassCode, isEdit: isEdit);

      await result.fold(
        (Failure failure) async {
          errorMessage.value = failure.message;
          AppToast.error(failure.message);
        },
        (String success) async {
          message.value = success;
          AppToast.success(success);

          await fetchProcess(processId);
        },
      );
    } catch (e) {
      AppToast.error("Ocorreu um erro ao tentar classificar o processo.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteJustificationProcess(int id) async {
    try {
      isLoading.value = true;
      message.value = '';

      final result = await _deleteJustification(id);

      result.fold(
        (failure) {
          message.value = failure.message;
          AppToast.error("Erro - ${message.value}");
        },
        (successMessage) async {
          message.value = successMessage;
          AppToast.success("Sucesso - ${message.value}");

          if (process.value != null) {
            await fetchProcess(process.value!.id);
          }
        },
      );
    } catch (e) {
      AppToast.error(
        "Erro inesperado - Ocorreu um erro ao tentar remover a justificativa",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadStatusProcess(int processId, String newStatus) async {
    try {
      isLoading.value = true;
      message.value = '';

      final result = await _updateStatusProcess(processId, newStatus);

      result.fold(
        (failure) {
          message.value = failure.message;
          AppToast.error("Erro - ${message.value}");
        },
        (successMessage) async {
          message.value = successMessage;
          AppToast.success("Sucesso - ${message.value}");

          if (process.value != null) {
            await fetchProcess(process.value!.id);
          }
        },
      );
    } catch (e) {
      AppToast.error(
        "Erro inesperado -Ocorreu um erro ao tentar atualizar o status do processo.",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
