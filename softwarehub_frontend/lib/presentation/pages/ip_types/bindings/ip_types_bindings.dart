import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nit_sgpi_frontend/domain/repositories/iip_types_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/get_iptypes.dart';
import 'package:nit_sgpi_frontend/infra/datasources/ip_types_remote_datasource.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/controllers/ip_types_controller.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../../infra/repositories/ip_types_repository_impl.dart';

class IpTypesBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<http.Client>(() => http.Client());
    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<http.Client>(),
      ),
    );
    Get.lazyPut<IIpTypesRemoteDataSource>(
      () => IpTypesRemoteDataSourceImpl(Get.find<ApiClient>()),
    );
    // Repository
    Get.lazyPut<IipTypesRepository>(
      () => IpTypesRepositoryImpl(remoteDataSource: Get.find<IIpTypesRemoteDataSource>()),
    );
    // UseCase
    Get.lazyPut<GetIptypes>(
      () => GetIptypes(repository: Get.find<IipTypesRepository>()),
    );
    Get.lazyPut<IpTypesController>(
      () => IpTypesController(Get.find<GetIptypes>()),
    );
  }
}