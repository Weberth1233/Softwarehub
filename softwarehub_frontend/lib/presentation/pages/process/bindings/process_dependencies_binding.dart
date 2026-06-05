import 'package:get/get.dart';

import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/process_remote_datasource.dart';
import '../../../../infra/repositories/process_repository_impl.dart';

class ProcessDependenciesBinding {
  static void dependencies() {
    if (!Get.isRegistered<IProcessRemoteDataSource>()) {
      Get.lazyPut<IProcessRemoteDataSource>(
        () => ProcessRemoteDataSourceImpl(Get.find<ApiClient>()),
      );
    }

    if (!Get.isRegistered<IProcessRepository>()) {
      Get.lazyPut<IProcessRepository>(
        () => ProcessRepositoryImpl(
          remoteDataSource: Get.find<IProcessRemoteDataSource>(),
        ),
      );
    }
  }
}
