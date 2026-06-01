import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/usecases/get_user_logged.dart';
import 'package:nit_sgpi_frontend/domain/usecases/put_user.dart';
import 'package:nit_sgpi_frontend/presentation/pages/users/controllers/user_logged_controller.dart';

import '../../../../domain/repositories/iuser_repository.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/datasources/user_remote_datasource.dart';
import '../../../../infra/repositories/user_repository_impl.dart';

class UserLoggedBindigs extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
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
    Get.lazyPut<GetUserLogged>(
      () => GetUserLogged(
        repository: Get.find<IUserRepository>(),
      ),
    );

    Get.lazyPut<PutUser>(
      () => PutUser(
        repository: Get.find<IUserRepository>(),
      ),
    );
    // Controller
    Get.lazyPut<UserLoggedController>(
      () => UserLoggedController(Get.find<GetUserLogged>()),
    );
    
  }

}