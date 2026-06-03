import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import '../../../../../domain/usecases/auth/login_usecase.dart';
import '../../../../shared/controller/auth_controller.dart';

class LoginController extends GetxController {
  final LoginUsecase loginUseCase;

  LoginController(this.loginUseCase);

  RxBool loading = false.obs;
  RxString errorMessage = "".obs;

  Future<void> login(String email, String password) async {
    loading.value = true;
    errorMessage.value = "";
    // try {
    final result = await loginUseCase(email, password);

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (_) async {
        final authController = Get.find<AuthController>();
        await authController.loadSession();
        Get.offAllNamed("/home");
      },
    );
    loading.value = false;

    // } catch (e) {
    //   errorMessage.value = "Login ou senha inválidos!";
    // } finally {
    //   loading.value = false;
    // }
  }
}
