import 'package:get/get.dart';

import '../../../../domain/repositories/iuser_repository.dart';
import '../../../../domain/usecases/users/get_user_logged.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/user_remote_datasource.dart';
import '../../../../infra/repositories/user_repository_impl.dart';
import '../controllers/user_logged_controller.dart';

class UserLoggedDependenciesBinding {
  static void dependencies() {
    if (!Get.isRegistered<IUserRemoteDataSource>()) {
      Get.lazyPut<IUserRemoteDataSource>(
        () => UserRemoteDatasourcesImpl(Get.find<ApiClient>()),
      );
    }

    if (!Get.isRegistered<IUserRepository>()) {
      Get.lazyPut<IUserRepository>(
        () => UserRepositoryImpl(
          remoteDataSource: Get.find<IUserRemoteDataSource>(),
        ),
      );
    }
    if (!Get.isRegistered<GetUserLogged>()) {
      Get.lazyPut<GetUserLogged>(
        () => GetUserLogged(repository: Get.find<IUserRepository>()),
      );
    }

    if (!Get.isRegistered<UserLoggedController>()) {
      Get.lazyPut<UserLoggedController>(
        () => UserLoggedController(Get.find<GetUserLogged>()),
      );
    }
  }
}
