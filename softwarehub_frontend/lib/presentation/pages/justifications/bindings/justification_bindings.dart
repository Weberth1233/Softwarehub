import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/ijustification_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/post_justification.dart';
import 'package:nit_sgpi_frontend/domain/usecases/justification/put_justification.dart';
import 'package:nit_sgpi_frontend/infra/datasources/justiification_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/repositories/justification_repository_impl.dart';
import 'package:nit_sgpi_frontend/presentation/pages/justifications/controllers/justification_controller.dart';

import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';

class JustificationBindings extends Bindings{
  @override
  void dependencies() {
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
    Get.lazyPut<IJustificationRemoteDataSource>(
      () => JustificationRemoteDatasourceImpl(Get.find<ApiClient>()),
    );

    // Repository
    Get.lazyPut<IJustificationRepository>(
      () => JustificationRepositoryImpl(
        remoteDataSource: Get.find<IJustificationRemoteDataSource>(),
      ),
    );

    // UseCase
    Get.lazyPut<PostJustification>(
      () => PostJustification(
        repository: Get.find<IJustificationRepository>(),
      ),
    );

    Get.lazyPut<PutJustification>(
      () => PutJustification(
        repository: Get.find<IJustificationRepository>(),
      ),
    );

    // Controller
    Get.lazyPut<JustificationController>(
      () => JustificationController(Get.find<PostJustification>(), Get.find<PutJustification>()),
    );

  }
}