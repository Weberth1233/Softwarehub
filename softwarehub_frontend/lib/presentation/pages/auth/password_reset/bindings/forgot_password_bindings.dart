import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/usecases/auth/forgot_password.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/password_reset/controllers/forgot_password_controller.dart';

import '../../../../../domain/repositories/auth_repository.dart';
import '../../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../../infra/datasources/auth_remote_datasource.dart';
import '../../../../../infra/repositories/auth_repository_impl.dart';

class ForgotPasswordBindings extends Bindings {
  @override
  void dependencies() {
    // Data sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(http.Client()),
    );
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());
    // Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<AuthRemoteDataSource>(),
        Get.find<AuthLocalDataSource>(),
      ),
    );
    // Use case
    Get.lazyPut<ForgotPassword>(
      () => ForgotPassword(repository: Get.find<AuthRepository>()),
    );
    // Controller
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(Get.find<ForgotPassword>()),
    );
  }
}
