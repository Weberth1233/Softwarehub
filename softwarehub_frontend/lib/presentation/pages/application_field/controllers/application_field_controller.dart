import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/application_field_entity.dart';
import '../../../../domain/usecases/application_field/get_paginated_list_application_field.dart';

class ApplicationFieldController extends GetxController {
  final GetPaginatedListApplicationField _getPaginatedListApplicationField;

  ApplicationFieldController(this._getPaginatedListApplicationField);

  final TextEditingController searchController = TextEditingController();

  final RxBool isLoadingList = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<ApplicationFieldEntity> applicationFields =
      <ApplicationFieldEntity>[].obs;

  final RxString search = ''.obs;

  final RxInt currentPage = 0.obs;
  final RxInt totalPages = 0.obs;

  final RxSet<int> selectedFieldIds = <int>{}.obs;

  final RxBool isEditMode = false.obs;

  final int size = 10;

  Map<String, List<ApplicationFieldEntity>> get groupedByApplicationArea {
    final Map<String, List<ApplicationFieldEntity>> grouped = {};

    for (final field in applicationFields) {
      final areaName = _getAreaName(field);

      grouped.putIfAbsent(areaName, () => []);
      grouped[areaName]!.add(field);
    }

    return grouped;
  }

  String get screenTitle {
    return isEditMode.value
        ? "Editar Campos de Aplicação"
        : "Selecionar Campos de Aplicação";
  }

  String get confirmButtonText {
    return isEditMode.value ? "Salvar alterações" : "Confirmar seleção";
  }

  @override
  void onInit() {
    super.onInit();

    _loadArguments();
    fetchApplicationFields();
  }

  String _getAreaName(ApplicationFieldEntity field) {
    return field.applicationAreaName.trim().isNotEmpty
        ? field.applicationAreaName.trim()
        : 'Área não informada';
  }

  void _loadArguments() {
    selectedFieldIds.clear();
    isEditMode.value = false;

    final args = Get.arguments;

    if (args is! Map<String, dynamic>) return;

    final editModeArg = args['isEditMode'];
    if (editModeArg is bool) {
      isEditMode.value = editModeArg;
    }

    final selectedIds = args['selectedApplicationFieldIds'];

    if (selectedIds is List) {
      selectedFieldIds.addAll(
        selectedIds.map((item) => int.parse(item.toString())),
      );
    }

    if (selectedFieldIds.isNotEmpty) {
      isEditMode.value = true;
    }
  }

  Future<void> fetchApplicationFields({int page = 0}) async {
    if (isLoadingList.value) return;

    isLoadingList.value = true;
    errorMessage.value = '';

    final values = <String, String>{
      'page': page.toString(),
      'page-size': size.toString(),
    };

    if (search.value.trim().isNotEmpty) {
      values['description'] = search.value.trim();
    }

    final result = await _getPaginatedListApplicationField(values);

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (pagedResult) {
        applicationFields.assignAll(pagedResult.content);
        currentPage.value = pagedResult.number;
        totalPages.value = pagedResult.totalPages;
      },
    );

    isLoadingList.value = false;
  }

  bool isFieldSelected(int fieldId) {
    return selectedFieldIds.contains(fieldId);
  }

  void toggleFieldSelection(ApplicationFieldEntity field) {
    final fieldId = field.id;

    if (selectedFieldIds.contains(fieldId)) {
      selectedFieldIds.remove(fieldId);
    } else {
      selectedFieldIds.add(fieldId);
    }

    selectedFieldIds.refresh();
  }

  bool isAreaFullySelected(List<ApplicationFieldEntity> fields) {
    if (fields.isEmpty) return false;

    return fields.every((field) => selectedFieldIds.contains(field.id));
  }

  bool isAreaPartiallySelected(List<ApplicationFieldEntity> fields) {
    if (fields.isEmpty) return false;

    final hasSelected = fields.any(
      (field) => selectedFieldIds.contains(field.id),
    );

    final allSelected = isAreaFullySelected(fields);

    return hasSelected && !allSelected;
  }

  void toggleAreaSelection(List<ApplicationFieldEntity> fields) {
    if (fields.isEmpty) return;

    final allSelected = isAreaFullySelected(fields);

    if (allSelected) {
      for (final field in fields) {
        selectedFieldIds.remove(field.id);
      }
    } else {
      for (final field in fields) {
        selectedFieldIds.add(field.id);
      }
    }

    selectedFieldIds.refresh();
  }

  void confirmSelection() {
    Get.back(result: selectedFieldIds.toList());
  }

  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      fetchApplicationFields(page: currentPage.value + 1);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      fetchApplicationFields(page: currentPage.value - 1);
    }
  }

  void goToPage(int page) {
    fetchApplicationFields(page: page);
  }

  void searchByName(String value) {
    search.value = value;
    fetchApplicationFields(page: 0);
  }

  void clearSearch() {
    searchController.clear();
    search.value = '';
    fetchApplicationFields(page: 0);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
