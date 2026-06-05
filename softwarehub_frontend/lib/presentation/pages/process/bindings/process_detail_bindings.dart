import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/usecases/process/process_classification.dart';
import 'package:nit_sgpi_frontend/domain/usecases/process/update_status_process.dart';
import 'package:nit_sgpi_frontend/presentation/core/bindigs/core_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_detail_controller.dart';

import '../../../../domain/repositories/ijustification_repository.dart';
import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../domain/usecases/justification/delete_justification.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/datasources/justiification_remote_datasource.dart';
import '../../../../infra/datasources/process_remote_datasource.dart';
import '../../../../infra/repositories/justification_repository_impl.dart';
import '../../../../infra/repositories/process_repository_impl.dart';

class ProcessDetailBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();

    Get.lazyPut<IProcessRemoteDataSource>(
      () => ProcessRemoteDataSourceImpl(Get.find<ApiClient>()),
    );

    Get.lazyPut<IJustificationRemoteDataSource>(
      () => JustificationRemoteDatasourceImpl(Get.find<ApiClient>()),
    );

    Get.lazyPut<IProcessRepository>(
      () => ProcessRepositoryImpl(
        remoteDataSource: Get.find<IProcessRemoteDataSource>(),
      ),
    );

    ///Passar pra outro bindings
    Get.lazyPut<IJustificationRepository>(
      () => JustificationRepositoryImpl(
        remoteDataSource: Get.find<IJustificationRemoteDataSource>(),
      ),
    );
    Get.lazyPut<DeleteJustification>(
      () =>
          DeleteJustification(repository: Get.find<IJustificationRepository>()),
    );

    Get.lazyPut<GetProcessById>(
      () => GetProcessById(repository: Get.find<IProcessRepository>()),
    );

    Get.lazyPut<UpdateStatusProcess>(
      () => UpdateStatusProcess(repository: Get.find<IProcessRepository>()),
    );

    Get.lazyPut<ProcessClassification>(
      () => ProcessClassification(repository: Get.find<IProcessRepository>()),
    );

    Get.lazyPut<ProcessDetailController>(
      () => ProcessDetailController(
        Get.find<GetProcessById>(),
        Get.find<AuthLocalDataSource>(),
        Get.find<DeleteJustification>(),
        Get.find<UpdateStatusProcess>(),
        Get.find<ProcessClassification>()
      ),
    );
  }
}
