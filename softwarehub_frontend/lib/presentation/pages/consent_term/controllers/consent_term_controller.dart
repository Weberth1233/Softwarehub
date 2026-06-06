import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/consent_term/get_consent_term_was_accepted.dart';
import 'package:nit_sgpi_frontend/domain/usecases/consent_term/post_consent_term_acceptance.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/app_toast.dart';
import '../../../../domain/entities/consent_term_entity.dart';
import '../../../../domain/usecases/consent_term/get_consent_term_by_iptypes.dart';

class ConsentTermController extends GetxController {
  final GetConsentTermByIpTypes _getConsentTermByIpTypes;
  final PostConsentTermAcceptance _postConsentTermAcceptance;
  final GetConsentTermWasAccepted _getConsentTermWasAccepted;

  ConsentTermController(
    this._getConsentTermByIpTypes,
    this._postConsentTermAcceptance,
    this._getConsentTermWasAccepted,
  );

  var consentTerm = Rxn<ConsentTermEntity>();

  var wasAccepted = false.obs;
  var accepted = false.obs;

  var isLoading = false.obs;
  var isPosting = false.obs;

  var errorMessage = ''.obs;
  var message = ''.obs;

  Future<bool> prepareConsentTermScreen(int ipTypeId) async {
    isLoading.value = true;
    errorMessage.value = '';
    message.value = '';
    accepted.value = false;
    wasAccepted.value = false;
    consentTerm.value = null;

    final consentTermResult = await _getConsentTermByIpTypes(ipTypeId);

    bool alreadyAccepted = false;

    await consentTermResult.fold(
      (failure) async {
        errorMessage.value = failure.message;
      },
      (term) async {
        consentTerm.value = term;

        final wasAcceptedResult = await _getConsentTermWasAccepted(term.id);

        wasAcceptedResult.fold(
          (failure) {
            errorMessage.value = failure.message;
          },
          (response) {
            alreadyAccepted = response;
            wasAccepted.value = response;
          },
        );
      },
    );

    isLoading.value = false;

    return alreadyAccepted;
  }

  Future<void> fetchConsentTermByIpTypesId(int ipTypeId) async {
    isLoading.value = true;
    errorMessage.value = '';
    accepted.value = false;
    consentTerm.value = null;

    final result = await _getConsentTermByIpTypes(ipTypeId);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (response) {
        consentTerm.value = response;
      },
    );

    isLoading.value = false;
  }

  Future<bool> checkConsentTermWasAccepted(int consentTermId) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getConsentTermWasAccepted(consentTermId);

    bool alreadyAccepted = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (response) {
        alreadyAccepted = response;
        wasAccepted.value = response;
      },
    );

    isLoading.value = false;

    return alreadyAccepted;
  }

  Future<bool> postConsentTermAcceptance(int consentTermId) async {
    isPosting.value = true;
    errorMessage.value = '';
    message.value = '';

    final result = await _postConsentTermAcceptance(consentTermId);

    bool success = false;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (response) {
        success = true;
        message.value = 'Termo aceito com sucesso.';
        wasAccepted.value = true;
      },
    );

    isPosting.value = false;

    return success;
  }

  void reset() {
    consentTerm.value = null;
    wasAccepted.value = false;
    accepted.value = false;
    isLoading.value = false;
    isPosting.value = false;
    errorMessage.value = '';
    message.value = '';
  }

  Future<void> goToFormOrConsentTerm({
    required int ipTypeId,
    required String nextRoute,
    required dynamic nextArguments,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    message.value = '';
    accepted.value = false;
    consentTerm.value = null;

    final consentTermResult = await _getConsentTermByIpTypes(ipTypeId);

    await consentTermResult.fold(
      (failure) async {
        isLoading.value = false;

        AppToast.error("Erro -  ${failure.message}");
      },
      (term) async {
        final wasAcceptedResult = await _getConsentTermWasAccepted(term.id);

        wasAcceptedResult.fold(
          (failure) {
            isLoading.value = false;

            AppToast.error("Erro -  ${failure.message}");
          },
          (wasAccepted) {
            isLoading.value = false;

            if (wasAccepted) {
              Get.toNamed(nextRoute, arguments: nextArguments);
            } else {
              consentTerm.value = term;

              Get.toNamed(
                '/consent-term',
                arguments: {
                  'ipTypeId': ipTypeId,
                  'consentTerm': term,
                  'nextRoute': nextRoute,
                  'nextArguments': nextArguments,
                },
              );
            }
          },
        );
      },
    );
  }
}
