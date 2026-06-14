import 'package:get/get.dart';


import '../../../../domain/repositories/iapplication_field_repository.dart';
import '../../../../domain/usecases/application_field/get_paginated_list_application_field.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/application_field_remote_datasource.dart';
import '../../../../infra/repositories/application_field_repository_impl.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../controllers/application_field_controller.dart';

class ApplicationFieldBindings extends Bindings{
  @override
  void dependencies() {
    CoreBinding.dependencies();

    Get.lazyPut<IApplicationFieldRemoteDataSource>(
      () => ApplicationFieldRemoteDatasource(Get.find<ApiClient>()),
    );
    Get.lazyPut<IApplicationFieldRepository>(
      () => ApplicationFieldRepositoryImpl(
        remoteDataSource: Get.find<IApplicationFieldRemoteDataSource>(),
      ),
    );
     Get.lazyPut<GetPaginatedListApplicationField>(
      () => GetPaginatedListApplicationField(
        repository: Get.find<IApplicationFieldRepository>(),
      ),
    );
     Get.lazyPut<ApplicationFieldController>(
      () => ApplicationFieldController(
        Get.find<GetPaginatedListApplicationField>(),
      ),
    );
  }
}