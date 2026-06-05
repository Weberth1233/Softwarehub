import 'package:get/get.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/nice_classification_entity.dart';
import '../../../../domain/usecases/nice_classification/get_nice_classification.dart';

class NiceClassificationController extends GetxController {
  final GetNiceClassification _getNiceClassification;

  NiceClassificationController(this._getNiceClassification);

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final RxList<NiceClassificationEntity> niceClassifications =
      <NiceClassificationEntity>[].obs;

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
