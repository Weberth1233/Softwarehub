import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/post_justification.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/put_justification.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../shared/utils/app_toast.dart';

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
  void onReady() {
    super.onReady();
    _loadJustification();
  }

  void _loadJustification() {
    String? idStr = Get.parameters['id'];

    if (idStr != null && idStr.isNotEmpty) {
    } else if (Get.arguments is int) {
    }
  }

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
        Get.back(result: idProcess);
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
          AppToast.error("Erro -  ${failure.message}");
        },
        (success) async {
          message.value = successMessage;
          AppToast.success(successMessage);
          await onSuccess();
        },
      );
    } catch (e) {
      AppToast.error('Ocorreu um erro inesperado! Tente novamente!');
      
    } finally {
      isLoading.value = false;
    }
  }

}