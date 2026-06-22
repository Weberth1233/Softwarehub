import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/users/get_user_logged.dart';

import '../../../../domain/entities/user/user_entity.dart';

class UserLoggedController extends GetxController {
  final GetUserLogged _getUserLogged;
  
  UserLoggedController(this._getUserLogged);

  var user = Rxn<UserEntity>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var message = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoggedUser();
  }

  Future<void> fetchLoggedUser() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getUserLogged();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (userEntity) {
        user.value = userEntity;
      },
    );

    isLoading.value = false;
  }


}
