import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/auth/forgot_password.dart';

import '../../../../../domain/core/errors/failures.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPassword _forgotPassword;

  ForgotPasswordController(this._forgotPassword);

  RxBool loading = false.obs;
  RxString message = "".obs;

  Future<void> forgotPassword(String email) async {
    loading.value = true;
    message.value = "";
    final result = await _forgotPassword(email);
    result.fold(
      (Failure failure) {
        message.value = failure.message;       
      },
      (result) {
        message.value = result;

      },
    );
    loading.value = false;
  }
}
