import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/post_justification.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/put_justification.dart';
import '../../../../domain/core/errors/failures.dart';

class JustificationController extends GetxController {
  final PostJustification _postJustification;
  final PutJustification _putJustification;

  JustificationController(
    this._postJustification,
    this._putJustification,
  );


  final TextEditingController reasonController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }

  Future<void> post(int idProcess) async {
    await _executeAction(
      action: () => _postJustification(
        JustificationRequestEntity(
          idProcess: idProcess,
          reason: reasonController.text.trim(),
        ),
      ),
      successMessage: 'Justificativa enviada com sucesso!',
      onSuccess: () async {
        reasonController.clear();
        /*await Future.delayed(const Duration(milliseconds: 800));
        Get.offAllNamed('/home');*/
      },
    );
  }


  Future<void> put(int justificationId, int idProcess) async {
    await _executeAction(
      action: () => _putJustification(
        justificationId,
        JustificationRequestEntity(
          idProcess: idProcess,
          reason: reasonController.text.trim(),
        ),
      ),
      successMessage: 'Justificativa atualizada com sucesso!',
      onSuccess: () async {
        /*await Future.delayed(const Duration(milliseconds: 800));
        Get.offAllNamed('/home');*/
      },
    );
  }

  Future<void> _executeAction({
    required Future<dynamic> Function() action,
    required String successMessage,
    required Future<void> Function() onSuccess,
  }) async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      message.value = '';

      final result = await action();

      result.fold(
        (Failure failure) {
          message.value = failure.message;
          _showErrorSnackbar(failure.message);
        },
        (success) async {
          message.value = successMessage;
          _showSuccessSnackbar(successMessage);
          await onSuccess();
        },
      );
    } catch (e) {
      _showErrorSnackbar(
        'Ocorreu um erro inesperado. Tente novamente.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSuccessSnackbar(String text) {
    final colors = Get.theme.colorScheme;

    Get.snackbar(
      'Sucesso',
      text,
      backgroundColor: colors.primary,
      colorText: colors.onPrimary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );
  }

  void _showErrorSnackbar(String text) {
    final colors = Get.theme.colorScheme;

    Get.snackbar(
      'Erro',
      text,
      backgroundColor: colors.error,
      colorText: colors.onError,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}