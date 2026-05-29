import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/usecases/post_process.dart';
import 'package:nit_sgpi_frontend/domain/usecases/put_process.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/ip_types_page.dart';
import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/datasources/process_remote_datasource.dart';
import '../../../../infra/repositories/process_repository_impl.dart';
import '../../process/controllers/process_post_controller.dart';
import '../controllers/ip_types_form_controller.dart';

class IpTypesFormBinding extends Bindings {
  @override
  void dependencies() {

    // Http client puro
    Get.lazyPut<http.Client>(() => http.Client());

    // Local datasource (token)
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());

    // ApiClient (usa http.Client + AuthLocalDataSource)
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<http.Client>(),
        // Get.find<AuthLocalDataSource>(),
      ),
    );
    
   // Remote datasource
    Get.lazyPut<IProcessRemoteDataSource>(
      () => ProcessRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    
    // Repository
    Get.lazyPut<IProcessRepository>(
      () => ProcessRepositoryImpl(
        remoteDataSource: Get.find<IProcessRemoteDataSource>(),
      ),
    );

    Get.lazyPut<PostProcess>(
      () => PostProcess(
        repository: Get.find<IProcessRepository>(),
      ),
    );

    Get.lazyPut<PutProcess>(
      () => PutProcess(
        repository: Get.find<IProcessRepository>(),
      ),
    );

    Get.lazyPut<ProcessPostController>(
      () => ProcessPostController(Get.find<PostProcess>(), Get.find<PutProcess>()),
    );

    Get.lazyPut<IpTypesFormController>(() {
      final secodaryStage = Get.arguments as SecondStageProcess;
      return IpTypesFormController(secodaryStage);
    });
  }
}
