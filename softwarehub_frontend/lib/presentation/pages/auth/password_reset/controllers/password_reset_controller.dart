import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/auth/password_reset.dart';

import '../../../../../domain/core/errors/failures.dart';

class PasswordResetController extends GetxController{
  final PasswordReset _passwordReset;

  PasswordResetController(this._passwordReset);

  RxBool loading = false.obs;
  RxString message = "".obs;

  Future<void> passwordReset(String token, String newPassword) async {
    loading.value = true;
    message.value = "";
    final result = await _passwordReset(token, newPassword);
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