import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/nice_classification_entity.dart';
import '../../../../domain/usecases/nice_classification/get_nice_classification.dart';
import '../../../shared/utils/app_toast.dart';

class NiceClassificationController extends GetxController {
  final GetNiceClassification _getNiceClassification;

  NiceClassificationController(this._getNiceClassification);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final RxList<NiceClassificationEntity> niceClassifications =
      <NiceClassificationEntity>[].obs;
  @override
  void onReady() {
    super.onReady();
    _loadNiceClassification();
  }

  void _loadNiceClassification() {
    String? idStr = Get.parameters['id'];
    int processId = 0;

    if (idStr != null && idStr.isNotEmpty) {
      processId = int.tryParse(idStr) ?? 0;
    } else if (Get.arguments is int) {
      processId = Get.arguments as int;
    }

    // 3. Chama a API
    if (processId != 0) {
      fetchNiceClassifications();
    } else {
      debugPrint(
        "Erro: processId não foi encontrado na rota e nem nos argumentos.",
      );
      AppToast.error("ID do processo não identificado.");
    }
  }

  Future<void> fetchNiceClassifications() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getNiceClassification();

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (result) {
        niceClassifications.value = result;
      },
    );

    isLoading.value = false;
  }
}
