import 'package:get/get.dart';

import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../domain/repositories/iuser_repository.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../../domain/usecases/users/get_users.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/user_remote_datasource.dart';
import '../../../../infra/repositories/user_repository_impl.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../controllers/process_controller.dart';
import 'process_dependencies_binding.dart';

class ProcessBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();

    ProcessDependenciesBinding.dependencies();

    Get.lazyPut<IUserRemoteDataSource>(
      () => UserRemoteDatasourcesImpl(Get.find<ApiClient>()),
    );

    Get.lazyPut<IUserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<IUserRemoteDataSource>(),
      ),
    );

    Get.lazyPut<GetUsers>(
      () => GetUsers(repository: Get.find<IUserRepository>()),
    );

    Get.lazyPut<GetProcessById>(
      () => GetProcessById(repository: Get.find<IProcessRepository>()),
    );

    Get.lazyPut<ProcessController>(
      () => ProcessController(Get.find<GetUsers>(), Get.find<GetProcessById>()),
    );
  }
}
