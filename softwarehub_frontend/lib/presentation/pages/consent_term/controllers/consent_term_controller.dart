import 'package:get/get.dart';
import '../../../../domain/entities/consent_term_entity.dart';
import '../../../../domain/usecases/get_consent_term_by_iptypes.dart';

class ConsentTermController extends GetxController {
  final GetConsentTermByIpTypes _getConsentTermByIpTypes;

  ConsentTermController(this._getConsentTermByIpTypes);

  var consentTerm = Rxn<ConsentTermEntity>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var message = ''.obs;
  var accepted = false.obs;

  Future<void> fetchConsentTermByIpTypesId(int id) async {
    isLoading.value = true;
    errorMessage.value = '';
    accepted.value = false;

    final result = await _getConsentTermByIpTypes(id);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (result) {
        consentTerm.value = result;
      },
    );

    isLoading.value = false;
  }
}