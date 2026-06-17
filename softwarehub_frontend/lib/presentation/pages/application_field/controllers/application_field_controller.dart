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

  /// Guarda qual bloco/área foi selecionado durante uma busca.
  ///
  /// Essa trava só será usada quando:
  /// - existir texto pesquisado;
  /// - a pesquisa retornar mais de um bloco/área.
  final RxString selectedApplicationAreaName = ''.obs;

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

  /// Regra principal do bloqueio.
  ///
  /// Só bloqueia seleção entre blocos diferentes quando:
  /// - o usuário digitou algo na busca;
  /// - a busca retornou mais de um bloco/área.
  bool get shouldApplySearchAreaLock {
    return search.value.trim().isNotEmpty &&
        groupedByApplicationArea.length > 1;
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

  void _showDifferentAreaBlockedMessage() {
    Get.snackbar(
      'Seleção bloqueada',
      'Essa pesquisa retornou campos em blocos diferentes. Selecione apenas um bloco.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _clearSearchAreaLock() {
    selectedApplicationAreaName.value = '';
  }

  /// Depois de carregar uma página, tenta sincronizar a trava com os campos
  /// já selecionados que aparecem no resultado atual.
  ///
  /// Isso é importante no modo edição ou quando o usuário já tinha campos
  /// selecionados antes de pesquisar.
  void _syncSearchAreaLockWithCurrentResult() {
    if (!shouldApplySearchAreaLock) {
      _clearSearchAreaLock();
      return;
    }

    final selectedFieldsInCurrentResult = applicationFields.where(
      (field) => selectedFieldIds.contains(field.id),
    );

    if (selectedFieldsInCurrentResult.isEmpty) {
      _clearSearchAreaLock();
      return;
    }

    selectedApplicationAreaName.value =
        _getAreaName(selectedFieldsInCurrentResult.first);
  }

  /// Após remover uma seleção, verifica se ainda existe algum campo selecionado
  /// no resultado atual da busca.
  ///
  /// Se não existir, libera a trava para o usuário poder escolher outro bloco.
  void _clearSearchAreaLockIfNeeded() {
    if (!shouldApplySearchAreaLock) {
      _clearSearchAreaLock();
      return;
    }

    final hasSelectedFieldInCurrentResult = applicationFields.any(
      (field) => selectedFieldIds.contains(field.id),
    );

    if (!hasSelectedFieldInCurrentResult) {
      _clearSearchAreaLock();
    }
  }

  void _loadArguments() {
    selectedFieldIds.clear();
    _clearSearchAreaLock();
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

        _syncSearchAreaLockWithCurrentResult();
      },
    );

    isLoadingList.value = false;
  }

  bool isFieldSelected(int fieldId) {
    return selectedFieldIds.contains(fieldId);
  }

  bool isFieldBlocked(ApplicationFieldEntity field) {
    if (!shouldApplySearchAreaLock) return false;
    if (selectedApplicationAreaName.value.isEmpty) return false;

    final areaName = _getAreaName(field);

    return selectedApplicationAreaName.value != areaName &&
        !selectedFieldIds.contains(field.id);
  }

  bool isAreaBlocked(List<ApplicationFieldEntity> fields) {
    if (!shouldApplySearchAreaLock) return false;
    if (fields.isEmpty) return false;
    if (selectedApplicationAreaName.value.isEmpty) return false;

    final areaName = _getAreaName(fields.first);

    final hasSelectedFieldInThisArea = fields.any(
      (field) => selectedFieldIds.contains(field.id),
    );

    return selectedApplicationAreaName.value != areaName &&
        !hasSelectedFieldInThisArea;
  }

  void toggleFieldSelection(ApplicationFieldEntity field) {
    final fieldId = field.id;
    final areaName = _getAreaName(field);

    if (selectedFieldIds.contains(fieldId)) {
      selectedFieldIds.remove(fieldId);
      _clearSearchAreaLockIfNeeded();
      selectedFieldIds.refresh();
      return;
    }

    if (shouldApplySearchAreaLock &&
        selectedApplicationAreaName.value.isNotEmpty &&
        selectedApplicationAreaName.value != areaName) {
      _showDifferentAreaBlockedMessage();
      return;
    }

    if (shouldApplySearchAreaLock) {
      selectedApplicationAreaName.value = areaName;
    }

    selectedFieldIds.add(fieldId);
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
    if (fields.isEmpty) return;

    final areaName = _getAreaName(fields.first);
    final allSelected = isAreaFullySelected(fields);

    if (allSelected) {
      for (final field in fields) {
        selectedFieldIds.remove(field.id);
      }

      _clearSearchAreaLockIfNeeded();
      selectedFieldIds.refresh();
      return;
    }

    if (shouldApplySearchAreaLock &&
        selectedApplicationAreaName.value.isNotEmpty &&
        selectedApplicationAreaName.value != areaName) {
      _showDifferentAreaBlockedMessage();
      return;
    }

    if (shouldApplySearchAreaLock) {
      selectedApplicationAreaName.value = areaName;
    }

    for (final field in fields) {
      selectedFieldIds.add(field.id);
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

  void goToPage(int page) {
    fetchApplicationFields(page: page);
  }

  void searchByName(String value) {
    search.value = value;

    /// Nova busca, nova regra de trava.
    /// A trava será recalculada depois que os resultados carregarem.
    _clearSearchAreaLock();

    fetchApplicationFields(page: 0);
  }

  void clearSearch() {
    searchController.clear();
    search.value = '';

    /// Sem busca, não existe bloqueio entre blocos.
    _clearSearchAreaLock();

    fetchApplicationFields(page: 0);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}