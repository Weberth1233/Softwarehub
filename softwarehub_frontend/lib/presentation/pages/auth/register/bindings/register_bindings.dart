import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/iregister_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_by_zipcode.dart';
import 'package:nit_sgpi_frontend/domain/usecases/post_user.dart';
import 'package:nit_sgpi_frontend/infra/datasources/address_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/datasources/register_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/repositories/register_repository_impl.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/register/controllers/register_controller.dart';
import 'package:nit_sgpi_frontend/presentation/pages/users/controllers/user_logged_controller.dart' show UserLoggedController;

import '../../../../../domain/repositories/address_repository.dart';
import '../../../../../domain/repositories/iuser_repository.dart';
import '../../../../../domain/usecases/get_user_logged.dart';
import '../../../../../domain/usecases/put_user.dart';
import '../../../../../infra/core/network/api_client.dart';
import '../../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../../infra/datasources/user_remote_datasource.dart';
import '../../../../../infra/repositories/address_repository_impl.dart';
import '../../../../../infra/repositories/user_repository_impl.dart';

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IRegisterRemoteDataSource>(
      () => RegisterRemoteDatasource(http.Client()),
    );
    Get.lazyPut<IRegisterRepository>(
      () => RegisterRepositoryImpl(remoteDataSource: Get.find<IRegisterRemoteDataSource>()),
    );
    Get.lazyPut<PostUser>(
      () => PostUser(repository: Get.find<IRegisterRepository>()),
    );

    Get.lazyPut<http.Client>(() => http.Client());
    
    Get.lazyPut<IAddressRemoteDataSource>(() => AddressRemoteDataSource(http.Client()));

    Get.lazyPut<IAddressRepository>(
      () => AddressRepositoryImpl(remoteDataSource: Get.find<IAddressRemoteDataSource>()),
    );

    Get.lazyPut<GetByZipcode>(
      () => GetByZipcode(repository: Get.find<IAddressRepository>()),
    );

    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<http.Client>(),
      ),
    );
    Get.lazyPut<IUserRemoteDataSource>(
      () => UserRemoteDatasourcesImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<IUserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<IUserRemoteDataSource>(),
      ),
    );
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
    Get.lazyPut<UserLoggedController>(
      () => UserLoggedController(Get.find<GetUserLogged>()),
    );

     Get.lazyPut<RegisterController>(
      () => RegisterController(Get.find<PostUser>(), Get.find<PutUser>(), Get.find<GetByZipcode>()),
    );
  }
}
