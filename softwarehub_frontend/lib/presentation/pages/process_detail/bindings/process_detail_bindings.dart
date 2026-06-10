import 'package:get/get.dart';
import '../../../../domain/repositories/ijustification_repository.dart';
import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../domain/usecases/justification/delete_justification.dart';
import '../../../../domain/usecases/justification/get_attachment_file.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../../domain/usecases/process/process_classification.dart';
import '../../../../domain/usecases/process/update_status_process.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/datasources/process_remote_datasource.dart';
import '../../../../infra/repositories/process_repository_impl.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../../justifications/bindings/justification_dependencies_binding.dart';
import '../controllers/process_detail_controller.dart';

class ProcessDetailBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();
    JustificationDependenciesBinding.dependencies();
    
    Get.lazyPut<IProcessRemoteDataSource>(
      () => ProcessRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<IProcessRepository>(
      () => ProcessRepositoryImpl(
        remoteDataSource: Get.find<IProcessRemoteDataSource>(),
      ),
    );

    Get.lazyPut<DeleteJustification>(
      () =>
          DeleteJustification(repository: Get.find<IJustificationRepository>()),
    );

    Get.lazyPut<GetAttachmentFile>(
      () =>
          GetAttachmentFile(repository: Get.find<IJustificationRepository>()),
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
        Get.find<ProcessClassification>(),
        Get.find<GetAttachmentFile>()
      ),
    );
  }
}
