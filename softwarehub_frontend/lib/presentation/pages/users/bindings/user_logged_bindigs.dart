import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/users/bindings/user_logged_dependencies_binding.dart';
import '../../../../domain/repositories/iuser_repository.dart';
import '../../../../domain/usecases/users/put_user.dart';
import '../../../core/bindigs/core_bindings.dart';

class UserLoggedBindigs extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();

    UserLoggedDependenciesBinding.dependencies();

    Get.lazyPut<PutUser>(
      () => PutUser(repository: Get.find<IUserRepository>()),
    );

  //   Get.lazyPut<UserLoggedController>(
  //     () => UserLoggedController(Get.find<GetUserLogged>()),
  //   );
  // }
  }
}
