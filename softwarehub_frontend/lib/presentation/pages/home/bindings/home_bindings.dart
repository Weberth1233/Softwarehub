import 'package:get/get.dart';
import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../domain/usecases/process/delete_process.dart';
import '../../../../domain/usecases/process/get_process.dart';
import '../../../../domain/usecases/process/get_process_status_count.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/process_remote_datasource.dart';
import '../../../../infra/repositories/process_repository_impl.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../../users/bindings/user_logged_dependencies_binding.dart';
import '../controllers/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();
    UserLoggedDependenciesBinding.dependencies();

    Get.lazyPut<IProcessRemoteDataSource>(
      () => ProcessRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<IProcessRepository>(
      () => ProcessRepositoryImpl(
        remoteDataSource: Get.find<IProcessRemoteDataSource>(),
      ),
    );
    Get.lazyPut<GetProcesses>(
      () => GetProcesses(repository: Get.find<IProcessRepository>()),
    );
    Get.lazyPut<GetProcessStatusCount>(
      () => GetProcessStatusCount(repository: Get.find<IProcessRepository>()),
    );
    Get.lazyPut<DeleteProcess>(
      () => DeleteProcess(repository: Get.find<IProcessRepository>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<GetProcesses>(),
        Get.find<GetProcessStatusCount>(),
        Get.find<DeleteProcess>(),
      ),
    );
  }
}
