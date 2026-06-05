import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/usecases/nice_classification/get_nice_classification.dart';
import 'package:nit_sgpi_frontend/infra/datasources/nice_classification_remote_datasource.dart';
import 'package:nit_sgpi_frontend/presentation/core/bindigs/core_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/nice_classification/controllers/nice_classification_controller.dart';

import '../../../../domain/repositories/inice_classification_repository.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/repositories/nice_classification_repository_impl.dart';

class NiceClassificationBinding extends Bindings {
  @override
  void dependencies() {
    print('NiceClassificationBinding executou');

    CoreBinding.dependencies();

    Get.lazyPut<INiceClassificationRemoteDatasource>(
      () => NiceClassificationRemoteDatasourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<INiceClassificationRepository>(
      () => NiceClassificationRepositoryImpl(
        remoteDataSource: Get.find<INiceClassificationRemoteDatasource>(),
      ),
    );
    Get.lazyPut<GetNiceClassification>(
      () => GetNiceClassification(
        repository: Get.find<INiceClassificationRepository>(),
      ),
    );
    Get.lazyPut<NiceClassificationController>(
      () => NiceClassificationController(Get.find<GetNiceClassification>()),
    );
  }
}
