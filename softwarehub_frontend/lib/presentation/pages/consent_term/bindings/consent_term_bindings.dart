import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/usecases/get_consent_term_by_iptypes.dart';
import 'package:nit_sgpi_frontend/infra/datasources/consent_term_remote_datasource.dart';
import 'package:nit_sgpi_frontend/presentation/pages/consent_term/controllers/consent_term_controller.dart';
import '../../../../domain/repositories/iconsent_term_repository.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/repositories/consent_term_repository_impl.dart';

class ConsentTermBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<http.Client>(),
      ),
    );
    Get.lazyPut<IConsentTermRemoteDataSource>(
      () => ConsentTermRemoteDatasourceImpl(Get.find<ApiClient>()),
    );
    // Repository
    Get.lazyPut<IConsentTermRepository>(
      () => ConsentTermRepositoryImpl(remoteDataSource: Get.find<IConsentTermRemoteDataSource>()),
    );
    // UseCase
    Get.lazyPut<GetConsentTermByIpTypes>(
      () => GetConsentTermByIpTypes(repository: Get.find<IConsentTermRepository>()),
    );
    
    Get.lazyPut<ConsentTermController>(
      () => ConsentTermController(Get.find<GetConsentTermByIpTypes>()),
    );
    
  }
}