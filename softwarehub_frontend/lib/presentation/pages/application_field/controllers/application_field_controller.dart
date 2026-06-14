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

  final int size = 10;

  Map<String, List<ApplicationFieldEntity>> get groupedByApplicationArea {
    final Map<String, List<ApplicationFieldEntity>> grouped = {};

    for (final field in applicationFields) {
      final areaName = field.applicationAreaName.trim().isNotEmpty
          ? field.applicationAreaName
          : 'Área não informada';

      if (!grouped.containsKey(areaName)) {
        grouped[areaName] = [];
      }

      grouped[areaName]!.add(field);
    }

    return grouped;
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      final selectedIds = args['selectedApplicationFieldIds'];

      if (selectedIds is List) {
        selectedFieldIds.addAll(
          selectedIds.map((e) => int.parse(e.toString())),
        );
      }
    }

    fetchApplicationFields();
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

  void toggleFieldSelection(int fieldId) {
    if (selectedFieldIds.contains(fieldId)) {
      selectedFieldIds.remove(fieldId);
    } else {
      selectedFieldIds.add(fieldId);
    }

    selectedFieldIds.refresh();
  }

  bool isAreaFullySelected(List<ApplicationFieldEntity> fields) {
    if (fields.isEmpty) return false;

    return fields.every(
      (field) => selectedFieldIds.contains(field.id),
    );
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
    Get.back(
      result: selectedFieldIds.toList(),
    );
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