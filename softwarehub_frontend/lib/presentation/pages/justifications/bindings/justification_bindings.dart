import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/repositories/ijustification_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/post_justification.dart';
import 'package:nit_sgpi_frontend/presentation/pages/justifications/bindings/justification_dependencies_binding.dart';
import 'package:nit_sgpi_frontend/presentation/pages/justifications/controllers/justification_controller.dart';
import '../../../../domain/usecases/justification/put_justification.dart';
import '../../../core/bindigs/core_bindings.dart';

class JustificationBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();

    JustificationDependenciesBinding.dependencies();

    // UseCase
    Get.lazyPut<PostJustification>(
      () => PostJustification(repository: Get.find<IJustificationRepository>()),
    );

    Get.lazyPut<PutJustification>(
      () => PutJustification(
        repository: Get.find<IJustificationRepository>(),
      ),
    );

    // Controller
    Get.lazyPut<JustificationController>(
      () => JustificationController(
        Get.find<PostJustification>(),
      Get.find<PutJustification>()),
    );
  }
}
