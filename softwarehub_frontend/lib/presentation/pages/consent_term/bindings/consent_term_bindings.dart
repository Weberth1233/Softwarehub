import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../domain/repositories/iconsent_term_acceptance_repository.dart';
import '../../../../domain/repositories/iconsent_term_repository.dart';
import '../../../../domain/usecases/get_consent_term_by_iptypes.dart';
import '../../../../domain/usecases/get_consent_term_was_accepted.dart';
import '../../../../domain/usecases/post_consent_term_acceptance.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/datasources/consent_term_acceptance_remote_datasource.dart';
import '../../../../infra/datasources/consent_term_remote_datasource.dart';
import '../../../../infra/repositories/consent_term_acceptance_repository_impl.dart';
import '../../../../infra/repositories/consent_term_repository_impl.dart';
import '../controllers/consent_term_controller.dart';

class ConsentTermBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());

    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<http.Client>()));

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
