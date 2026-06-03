import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_type_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_request_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/ip_types_page.dart';
import '../../process/controllers/process_post_controller.dart'
    show ProcessPostController;

class IpTypesFormController extends GetxController {
  final SecondStageProcess secondStageProcess;

  IpTypesFormController(this.secondStageProcess);

  final Map<String, TextEditingController> controllers = {};

  final RxMap<String, dynamic> formValues = <String, dynamic>{}.obs;

  final RxMap<String, String?> fieldErrors = <String, String?>{}.obs;

  List<IpTypeFieldEntity> get fields {
    final list = [...secondStageProcess.item.formStructure.fields];

    list.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    return list;
  }

  @override
  void onInit() {
    super.onInit();

    final isSameIpType =
        secondStageProcess.isEdit &&
        secondStageProcess.item.id.toString() ==
            secondStageProcess.originalIpTypeId;

    for (final field in fields) {
      String initialValue = '';

      if (isSameIpType && secondStageProcess.originalFormData != null) {
        initialValue =
            secondStageProcess.originalFormData![field.key]?.toString() ?? '';
      }

      controllers[field.key] = TextEditingController(text: initialValue);
      formValues[field.key] = initialValue;
      fieldErrors[field.key] = null;

      controllers[field.key]!.addListener(() {
        formValues[field.key] = controllers[field.key]!.text;
      });
    }
  }

  @override
  void onClose() {
    for (final c in controllers.values) {
      c.dispose();
    }

    super.onClose();
  }

  void updateFieldValue(
    String key,
    dynamic value, {
    bool updateController = false,
  }) {
    formValues[key] = value;

    if (fieldErrors.containsKey(key)) {
      fieldErrors[key] = null;
    }

    if (updateController && controllers.containsKey(key)) {
      final text = value?.toString() ?? '';

      if (controllers[key]!.text != text) {
        controllers[key]!.text = text;
      }
    }

    _clearInvisibleFields();
  }

  bool isFieldVisible(IpTypeFieldEntity field) {
    final conditional = field.conditional;

    if (conditional == null) {
      return true;
    }

    final dependsOnValue = formValues[conditional.dependsOn];

    switch (conditional.operator) {
      case 'equals':
        return dependsOnValue == conditional.value;

      case 'notEquals':
        return dependsOnValue != conditional.value;

      case 'isEmpty':
        return dependsOnValue == null || dependsOnValue.toString().isEmpty;

      case 'isNotEmpty':
        return dependsOnValue != null && dependsOnValue.toString().isNotEmpty;

      default:
        return true;
    }
  }

  void _clearInvisibleFields() {
    for (final field in fields) {
      if (!isFieldVisible(field)) {
        if ((controllers[field.key]?.text ?? '').isNotEmpty) {
          controllers[field.key]?.clear();
        }

        formValues[field.key] = '';
        fieldErrors[field.key] = null;
      }
    }
  }

  bool validate() {
    fieldErrors.clear();

    bool isValid = true;

    for (final field in fields) {
      if (!isFieldVisible(field)) {
        continue;
      }

      final value = controllers[field.key]?.text.trim() ?? '';

      if (field.requiredField && value.isEmpty) {
        fieldErrors[field.key] = 'Este campo é obrigatório';
        isValid = false;
        continue;
      }

      final validation = field.validation;

      if (validation != null && value.isNotEmpty) {
        if (validation.minLength != null &&
            value.length < validation.minLength!) {
          fieldErrors[field.key] =
              validation.message ??
              'Este campo deve ter no mínimo ${validation.minLength} caracteres';

          isValid = false;
          continue;
        }

        if (validation.maxLength != null &&
            value.length > validation.maxLength!) {
          fieldErrors[field.key] =
              validation.message ??
              'Este campo deve ter no máximo ${validation.maxLength} caracteres';

          isValid = false;
          continue;
        }

        if (field.type.toLowerCase() == 'number') {
          final numberValue = num.tryParse(value);

          if (numberValue == null) {
            fieldErrors[field.key] = 'Este campo deve ser um número válido';
            isValid = false;
            continue;
          }

          if (validation.min != null && numberValue < validation.min!) {
            fieldErrors[field.key] =
                validation.message ??
                'Este campo deve ser maior ou igual a ${validation.min}';

            isValid = false;
            continue;
          }

          if (validation.max != null && numberValue > validation.max!) {
            fieldErrors[field.key] =
                validation.message ??
                'Este campo deve ser menor ou igual a ${validation.max}';

            isValid = false;
            continue;
          }
        }

        if (validation.regex != null && validation.regex!.isNotEmpty) {
          final regex = RegExp(validation.regex!);

          if (!regex.hasMatch(value)) {
            fieldErrors[field.key] =
                validation.message ?? 'Este campo é inválido';

            isValid = false;
            continue;
          }
        }
      }
    }

    if (!isValid) {
      _showErrorSnackbar("Verifique os campos obrigatórios.");
    }

    return isValid;
  }

  void clearForm() {
    for (final c in controllers.values) {
      c.clear();
    }

    formValues.clear();
    fieldErrors.clear();
  }

  Future<void> submit() async {
    if (!validate()) return;

    final processController = Get.find<ProcessPostController>();
    final Map<String, dynamic> result = {};

    for (final field in fields) {
      if (!isFieldVisible(field)) {
        continue;
      }

      result[field.key] = controllers[field.key]?.text.trim() ?? '';
    }

    try {
      final request = ProcessRequestEntity(
        title: secondStageProcess.firstStageProcess.title,
        ipTypeId: secondStageProcess.item.id,
        externalAuthorIds:
            secondStageProcess.firstStageProcess.idsExternalAuthors,
        isFeatured: true,
        authorIds: secondStageProcess.firstStageProcess.idsUser,
        formData: result,
      );

      if (secondStageProcess.isEdit &&
          secondStageProcess.firstStageProcess.idProcess != null) {
        await processController.put(
          secondStageProcess.firstStageProcess.idProcess!,
          request,
        );
      } else {
        await processController.post(request);
      }

      _showSuccessSnackbar(
        secondStageProcess.isEdit
            ? "Processo atualizado com sucesso!"
            : "Sucesso ao cadastrar processo!",
      );

      clearForm();
      Get.offAllNamed('/home');
    } catch (e) {
      _showErrorSnackbar("Erro ao enviar processo");
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