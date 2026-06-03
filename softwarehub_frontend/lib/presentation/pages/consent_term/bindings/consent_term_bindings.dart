import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/core/bindigs/core_bindings.dart';
import '../../../../domain/repositories/iconsent_term_acceptance_repository.dart';
import '../../../../domain/repositories/iconsent_term_repository.dart';
import '../../../../domain/usecases/consent_term/get_consent_term_by_iptypes.dart';
import '../../../../domain/usecases/consent_term/get_consent_term_was_accepted.dart';
import '../../../../domain/usecases/consent_term/post_consent_term_acceptance.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/consent_term_acceptance_remote_datasource.dart';
import '../../../../infra/datasources/consent_term_remote_datasource.dart';
import '../../../../infra/repositories/consent_term_acceptance_repository_impl.dart';
import '../../../../infra/repositories/consent_term_repository_impl.dart';
import '../controllers/consent_term_controller.dart';

class ConsentTermBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();

    Get.lazyPut<IConsentTermRemoteDataSource>(
      () => ConsentTermRemoteDatasourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<IConsentTermAcceptanceRemoteDataSource>(
      () => ConsentTermAcceptanceRemoteDataSourceImpl(Get.find<ApiClient>()),
    );

    // Repository
    Get.lazyPut<IConsentTermRepository>(
      () => ConsentTermRepositoryImpl(
        remoteDataSource: Get.find<IConsentTermRemoteDataSource>(),
      ),
    );

    Get.lazyPut<IConsentTermAcceptanceRepository>(
      () => ConsentTermAcceptanceRepositoryImpl(
        remoteDataSource: Get.find<IConsentTermAcceptanceRemoteDataSource>(),
      ),
    );

    // UseCase
    Get.lazyPut<GetConsentTermByIpTypes>(
      () => GetConsentTermByIpTypes(
        repository: Get.find<IConsentTermRepository>(),
      ),
    );

    Get.lazyPut<GetConsentTermWasAccepted>(
      () => GetConsentTermWasAccepted(
        repository: Get.find<IConsentTermAcceptanceRepository>(),
      ),
    );

    Get.lazyPut<PostConsentTermAcceptance>(
      () => PostConsentTermAcceptance(
        repository: Get.find<IConsentTermAcceptanceRepository>(),
      ),
    );

    Get.lazyPut<ConsentTermController>(
      () => ConsentTermController(
        Get.find<GetConsentTermByIpTypes>(),
        Get.find<PostConsentTermAcceptance>(),
        Get.find<GetConsentTermWasAccepted>(),
      ),
    );
  }
}
