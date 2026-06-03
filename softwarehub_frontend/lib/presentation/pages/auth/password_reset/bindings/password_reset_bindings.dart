import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/usecases/auth/password_reset.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/password_reset/controllers/password_reset_controller.dart';

import '../../../../../domain/repositories/auth_repository.dart';
import '../../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../../infra/datasources/auth_remote_datasource.dart';
import '../../../../../infra/repositories/auth_repository_impl.dart';

class PasswordResetBindings extends Bindings {
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
    Get.lazyPut<PasswordReset>(
      () => PasswordReset(repository: Get.find<AuthRepository>()),
    );
    // Controller
    Get.lazyPut<PasswordResetController>(
      () => PasswordResetController(Get.find<PasswordReset>()),
    );
  }
}
