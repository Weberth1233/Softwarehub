import 'package:get/get.dart';
import '../../../../../domain/repositories/iregister_repository.dart';
import '../../../../../domain/usecases/address/get_by_zipcode.dart';
import '../../../../../domain/usecases/educational_institution/get_educational_institutions.dart';
import '../../../../../domain/usecases/types_link/get_types_links.dart';
import '../../../../../domain/usecases/users/post_user.dart';
import '../../../../../domain/usecases/users/put_user.dart';
import '../../../../../infra/core/network/api_client.dart';
import '../../../../../infra/datasources/register_remote_datasource.dart';
import '../../../../../infra/repositories/register_repository_impl.dart';
import '../../../../core/bindigs/core_bindings.dart';
import '../controllers/register_controller.dart';
import 'address_binding.dart';
import 'educational_institution_binding.dart';
import 'types_link_binding.dart';
import 'user_binding.dart';

class RegisterBindings extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();
    AddressBinding.dependencies();
    UserBinding.dependencies();
    EducationalInstitutionBinding.dependencies();
    TypesLinkBinding.dependencies();

    Get.lazyPut<IRegisterRemoteDataSource>(
      () => RegisterRemoteDatasource(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<IRegisterRepository>(
      () => RegisterRepositoryImpl(
        remoteDataSource: Get.find<IRegisterRemoteDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<PostUser>(
      () => PostUser(
        repository: Get.find<IRegisterRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(
        Get.find<PostUser>(),
        Get.find<PutUser>(),
        Get.find<GetByZipcode>(),
        Get.find<GetEducationalInstitutions>(),
        Get.find<GetTypesLinks>(),
      ),
    );
  }
}