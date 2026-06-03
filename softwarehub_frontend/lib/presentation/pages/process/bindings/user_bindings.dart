import 'package:get/get.dart';
import 'package:http/http.dart' as http show Client;
import 'package:nit_sgpi_frontend/domain/repositories/iuser_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/users/get_users.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_user_controller.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/datasources/user_remote_datasource.dart';
import '../../../../infra/repositories/user_repository_impl.dart';
class UserBindings extends Bindings {
  @override
  void dependencies() {
    // Http client puro
    Get.lazyPut<http.Client>(() => http.Client());

    // Local datasource (token)
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());

    // ApiClient (usa http.Client + AuthLocalDataSource)
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<http.Client>(),
        // Get.find<AuthLocalDataSource>(),
      ),
    );

    // Remote datasource
    Get.lazyPut<IUserRemoteDataSource>(
      () => UserRemoteDatasourcesImpl(Get.find<ApiClient>()),
    );

    // Repository
    Get.lazyPut<IUserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<IUserRemoteDataSource>(),
      ),
    );

    // UseCase
    Get.lazyPut<GetUsers>(
      () => GetUsers(
        repository: Get.find<IUserRepository>(),
      ),
    );
    // Controller
    Get.lazyPut<ProcessUserController>(
      () => ProcessUserController(Get.find<GetUsers>()),
    );
  }
}
