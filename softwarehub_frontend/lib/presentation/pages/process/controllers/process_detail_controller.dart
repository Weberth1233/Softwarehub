import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/delete_justification.dart';
import 'package:nit_sgpi_frontend/domain/usecases/process/get_process_by_id.dart';
import 'package:nit_sgpi_frontend/domain/usecases/process/process_classification.dart';
import 'package:nit_sgpi_frontend/domain/usecases/process/update_status_process.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../shared/utils/app_toast.dart';

class ProcessDetailController extends GetxController {
  final GetProcessById _getProcessById;
  final DeleteJustification _deleteJustification;
  final UpdateStatusProcess _updateStatusProcess;
  final ProcessClassification _processClassification;
  final AuthLocalDataSource _authLocal;

  ProcessDetailController(
    this._getProcessById,
    this._authLocal,
    this._deleteJustification,
    this._updateStatusProcess,
    this._processClassification,
  );

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  final RxString message = ''.obs;

  final Rxn<ProcessResponseEntity> process = Rxn<ProcessResponseEntity>();

  final RxString userRole = ''.obs;

  bool get isAdmin => userRole.value == 'ADMIN';

  @override
  void onInit() {
    super.onInit();
    _checkRole();
    _loadProcessId();
  }

  @override
  void onClose() {
    process.value = null;
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
        // Falha
        isLoading.value = false;
        errorMessage.value = failure.message;
        process.value = null;

        AppToast.error("Falha ao carregar processo: ${failure.message}");
      },
      (ProcessResponseEntity success) {
        // Sucesso
        isLoading.value = false;
        process.value = success;
      },
    );
  }

  Future<void> classifyProcess(int processId, int niceClassCode) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      message.value = '';

      final result = await _processClassification(processId, niceClassCode);

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

          // 🔥 Recarrega o processo atualizado
          if (process.value != null) {
            await fetchProcess(process.value!.id);
          }
        },
      );
    } catch (e) {
      
      AppToast.error("Erro inesperado - Ocorreu um erro ao tentar remover a justificativa");
      
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

          // 🔥 Recarrega o processo atualizado
          if (process.value != null) {
            await fetchProcess(process.value!.id);
          }
        },
      );
    } catch (e) {
      AppToast.error("Erro inesperado -Ocorreu um erro ao tentar atualizar o status do processo.");
    } finally {
      isLoading.value = false;
    }
  }
}
