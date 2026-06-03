import 'package:get/get.dart';
import 'package:http/http.dart' as http show Client;
import '../../../../../domain/repositories/auth_repository.dart';
import '../../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../../infra/datasources/auth_remote_datasource.dart';
import '../../../../../infra/repositories/auth_repository_impl.dart';
import '../controllers/login_controller.dart';

class LoginBindings extends Bindings{
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(http.Client()),
    );
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSource(),
    );
    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<AuthRemoteDataSource>(),
        Get.find<AuthLocalDataSource>(),
      ),
    );
    // Use case
    Get.lazyPut<LoginUsecase>(
      () => LoginUsecase(repository: Get.find<AuthRepository>()),
    );
    // Controller
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<LoginUsecase>()),
    );
  }
}