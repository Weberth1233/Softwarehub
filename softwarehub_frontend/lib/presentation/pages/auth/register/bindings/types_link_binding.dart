import 'package:get/get.dart';
import '../../../../../domain/repositories/itypes_link_repository.dart';
import '../../../../../domain/usecases/types_link/get_types_links.dart';
import '../../../../../infra/core/network/api_client.dart';
import '../../../../../infra/datasources/types_link_remote_datasource.dart';
import '../../../../../infra/repositories/types_link_repository_impl.dart';

class TypesLinkBinding {
  static void dependencies() {
    Get.lazyPut<ITypesLinkRemoteDatasource>(
      () => TypesLinkRemoteDatasource(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<ITypesLinkRepository>(
      () => TypesLinkRepositoryImpl(
        remoteDataSource: Get.find<ITypesLinkRemoteDatasource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<GetTypesLinks>(
      () => GetTypesLinks(
        repository: Get.find<ITypesLinkRepository>(),
      ),
      fenix: true,
    );
  }
}