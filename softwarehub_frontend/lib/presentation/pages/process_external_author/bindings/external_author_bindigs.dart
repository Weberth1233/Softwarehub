import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/iexternal_author_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/external_author/get_external_authors.dart';
import 'package:nit_sgpi_frontend/domain/usecases/external_author/post_external_author.dart';
import 'package:nit_sgpi_frontend/domain/usecases/external_author/put_external_author.dart';
import 'package:nit_sgpi_frontend/infra/datasources/external_author_datasource.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process_external_author/controllers/process_external_author_controller.dart';

import '../../../../domain/usecases/external_author/delete_external_author.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/repositories/external_author_repository_impl.dart';

class ExternalAuthorBindigs extends Bindings {
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
    Get.lazyPut<IExternalAuthorRemoteDataSource>(
      () => ExternalAuthorDatasource(Get.find<ApiClient>()),
    );

    // Repository
    Get.lazyPut<IExternalAuthorRepository>(
      () => ExternalAuthorRepositoryImpl(
        remoteDataSource: Get.find<IExternalAuthorRemoteDataSource>(),
      ),
    );

    // UseCase
    Get.lazyPut<GetExternalAuthors>(
      () => GetExternalAuthors(
        repository: Get.find<IExternalAuthorRepository>(),
      ),
    );

    Get.lazyPut<PostExternalAuthor>(
      () => PostExternalAuthor(
        repository: Get.find<IExternalAuthorRepository>(),
      ),
    );

    Get.lazyPut<DeleteExternalAuthor>(
      () => DeleteExternalAuthor(
        repository: Get.find<IExternalAuthorRepository>(),
      ),
    );
    
    Get.lazyPut<PutExternalAuthor>(
      () => PutExternalAuthor(
        repository: Get.find<IExternalAuthorRepository>(),
      ),
    );
    // Controller
    Get.lazyPut<ProcessExternalAuthorController>(
      () => ProcessExternalAuthorController(Get.find<GetExternalAuthors>(), Get.find<PostExternalAuthor>(), Get.find<DeleteExternalAuthor>(), Get.find<PutExternalAuthor>()),
    );
  }
}