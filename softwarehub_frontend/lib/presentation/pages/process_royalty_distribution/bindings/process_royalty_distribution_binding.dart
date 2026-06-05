import 'package:get/get.dart';
import '../../../../domain/repositories/iprocess_repository.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../../process/bindings/process_dependencies_binding.dart';
import '../controllers/process_royalty_distribution_controller.dart';

class ProcessRoyaltyDistributionBinding extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();
    ProcessDependenciesBinding.dependencies();

    Get.lazyPut<GetProcessById>(
      () => GetProcessById(repository: Get.find<IProcessRepository>()),
    );

    Get.lazyPut<ProcessRoyaltyDistributionController>(
      () => ProcessRoyaltyDistributionController(Get.find<GetProcessById>()),
    );
  }
}
