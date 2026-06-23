import 'package:get/get.dart';
import '../../../../domain/repositories/iexternal_author_repository.dart';
import '../../../../domain/usecases/external_author/delete_external_author.dart';
import '../../../../domain/usecases/external_author/get_external_authors.dart';
import '../../../../domain/usecases/external_author/post_external_author.dart';
import '../../../../domain/usecases/external_author/put_external_author.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/external_author_datasource.dart';
import '../../../../infra/repositories/external_author_repository_impl.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../controllers/process_external_author_controller.dart';

class ExternalAuthorBindigs extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();

    Get.lazyPut<IExternalAuthorRemoteDataSource>(
      () => ExternalAuthorDataSource(Get.find<ApiClient>()),
    );
    Get.lazyPut<IExternalAuthorRepository>(
      () => ExternalAuthorRepositoryImpl(
        remoteDataSource: Get.find<IExternalAuthorRemoteDataSource>(),
      ),
    );
    Get.lazyPut<GetExternalAuthors>(
      () =>
          GetExternalAuthors(repository: Get.find<IExternalAuthorRepository>()),
    );
    Get.lazyPut<PostExternalAuthor>(
      () =>
          PostExternalAuthor(repository: Get.find<IExternalAuthorRepository>()),
    );
    Get.lazyPut<DeleteExternalAuthor>(
      () => DeleteExternalAuthor(
        repository: Get.find<IExternalAuthorRepository>(),
      ),
    );
    Get.lazyPut<PutExternalAuthor>(
      () =>
          PutExternalAuthor(repository: Get.find<IExternalAuthorRepository>()),
    );

    Get.lazyPut<ProcessExternalAuthorController>(
      () => ProcessExternalAuthorController(
        Get.find<GetExternalAuthors>(),
        Get.find<PostExternalAuthor>(),
        Get.find<DeleteExternalAuthor>(),
        Get.find<PutExternalAuthor>(),
      ),
    );
  }
}
