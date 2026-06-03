import 'package:get/get.dart';
import '../../../../../domain/repositories/iuser_repository.dart';
import '../../../../../domain/usecases/users/get_user_logged.dart';
import '../../../../../domain/usecases/users/put_user.dart';
import '../../../../../infra/core/network/api_client.dart';
import '../../../../../infra/datasources/user_remote_datasource.dart';
import '../../../../../infra/repositories/user_repository_impl.dart';
import '../../../users/controllers/user_logged_controller.dart';


class UserBinding {
  static void dependencies() {
    Get.lazyPut<IUserRemoteDataSource>(
      () => UserRemoteDatasourcesImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<IUserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<IUserRemoteDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<GetUserLogged>(
      () => GetUserLogged(
        repository: Get.find<IUserRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PutUser>(
      () => PutUser(
        repository: Get.find<IUserRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<UserLoggedController>(
      () => UserLoggedController(
        Get.find<GetUserLogged>(),
      ),
      fenix: true,
    );
  }
}