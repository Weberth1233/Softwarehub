import 'package:get/get.dart';

import '../../../../domain/repositories/ijustification_repository.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/justiification_remote_datasource.dart';
import '../../../../infra/repositories/justification_repository_impl.dart';

class JustificationDependenciesBinding {
   static void dependencies() {
    if (!Get.isRegistered<IJustificationRemoteDataSource>()) {
      Get.lazyPut<IJustificationRemoteDataSource>(
        () => JustificationRemoteDatasourceImpl(Get.find<ApiClient>()),
      );
    }

    if (!Get.isRegistered<IJustificationRepository>()) {
      Get.lazyPut<IJustificationRepository>(
        () => JustificationRepositoryImpl(
          remoteDataSource: Get.find<IJustificationRemoteDataSource>(),
        ),
      );
    }
  }
}