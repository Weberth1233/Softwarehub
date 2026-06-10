import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nit_sgpi_frontend/domain/entities/justification/justification_request_entity.dart';
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

  // Arquivo selecionado
  final RxnString selectedFileName = RxnString();
  final RxnString selectedFilePath = RxnString();
  final Rxn<List<int>> selectedFileBytes = Rxn<List<int>>();

  @override
  void onReady() {
    super.onReady();
    _loadJustification();
  }

  void _loadJustification() {
    String? idStr = Get.parameters['id'];

    if (idStr != null && idStr.isNotEmpty) {
      // Caso precise carregar algo pelo ID depois
    } else if (Get.arguments is int) {
      // Caso venha por arguments
    }
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.first;

      selectedFileName.value = file.name;
      selectedFilePath.value = file.path;
      selectedFileBytes.value = file.bytes;

      AppToast.success('Arquivo selecionado com sucesso!');
    } catch (e) {
      AppToast.error('Erro ao selecionar arquivo!');
    }
  }

  void removeSelectedFile() {
    selectedFileName.value = null;
    selectedFilePath.value = null;
    selectedFileBytes.value = null;
  }

  Future<void> post(int idProcess) async {
    await _executeAction(
      action: () => _postJustification(
        JustificationRequestEntity(
          processId: idProcess,
          reason: reasonController.text.trim(),
          fileName: selectedFileName.value,
          filePath: selectedFilePath.value,
          fileBytes: selectedFileBytes.value,
        ),
      ),
      successMessage: 'Justificativa enviada com sucesso!',
      onSuccess: () async {
        clearForm();
        Get.back(result: idProcess);
      },
    );
  }

  Future<void> put({
    required int justificationId,
    required int idProcess,
  }) async {
    await _executeAction(
      action: () => _putJustification(
        justificationId,
        JustificationRequestEntity(
          processId: idProcess,
          reason: reasonController.text.trim(),
          fileName: selectedFileName.value,
          filePath: selectedFilePath.value,
          fileBytes: selectedFileBytes.value,
        ),
      ),
      successMessage: 'Justificativa atualizada com sucesso!',
      onSuccess: () async {
        clearForm();
        Get.back(result: idProcess);
      },
    );
  }

  void clearForm() {
    reasonController.clear();
    removeSelectedFile();
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
          AppToast.error("Erro - ${failure.message}");
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

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}