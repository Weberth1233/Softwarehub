import 'package:get/get.dart';

import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../domain/repositories/iprocess_royalty_distribution_repository.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../../domain/usecases/process_royalty_distribution/post_process_royalty_distribution.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/process_royalty_distribution_remote_datasource.dart';
import '../../../../infra/repositories/process_royalty_distribution_repository.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../../process/bindings/process_dependencies_binding.dart';
import '../controllers/process_royalty_distribution_controller.dart';

class ProcessRoyaltyDistributionBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();
    ProcessDependenciesBinding.dependencies();

    Get.lazyPut<IProcessRoyaltyDistributionRemoteDatasource>(
      () => ProcessRoyaltyDistributionRemoteDatasource(Get.find<ApiClient>()),
    );

    Get.lazyPut<IProcessRoyaltyDistributionRepository>(
      () => ProcessRoyaltyDistributionRepository(
        remoteDataSource:
            Get.find<IProcessRoyaltyDistributionRemoteDatasource>(),
      ),
    );

    Get.lazyPut<PostProcessRoyaltyDistribution>(
      () => PostProcessRoyaltyDistribution(
        repository: Get.find<IProcessRoyaltyDistributionRepository>(),
      ),
    );

    Get.lazyPut<GetProcessById>(
      () => GetProcessById(repository: Get.find<IProcessRepository>()),
    );

    if (Get.isRegistered<ProcessRoyaltyDistributionController>()) {
      Get.delete<ProcessRoyaltyDistributionController>(force: true);
    }

    Get.lazyPut<ProcessRoyaltyDistributionController>(
      () => ProcessRoyaltyDistributionController(
        Get.find<GetProcessById>(),
        Get.find<PostProcessRoyaltyDistribution>(),
      ),
    );
  }
}