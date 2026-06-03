import 'package:get/get.dart';
import '../../../../../domain/repositories/address_repository.dart';
import '../../../../../domain/usecases/address/get_by_zipcode.dart';
import '../../../../../infra/core/network/api_client.dart';
import '../../../../../infra/datasources/address_remote_datasource.dart';
import '../../../../../infra/repositories/address_repository_impl.dart';

class AddressBinding {
  static void dependencies() {
    Get.lazyPut<IAddressRemoteDataSource>(
      () => AddressRemoteDataSource(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<IAddressRepository>(
      () => AddressRepositoryImpl(
        remoteDataSource: Get.find<IAddressRemoteDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<GetByZipcode>(
      () => GetByZipcode(
        repository: Get.find<IAddressRepository>(),
      ),
      fenix: true,
    );
  }
}