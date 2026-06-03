import 'package:get/get.dart';

import '../../../../../domain/repositories/ieducational_institution_repository.dart';
import '../../../../../domain/usecases/educational_institution/get_educational_institutions.dart';
import '../../../../../infra/core/network/api_client.dart';
import '../../../../../infra/datasources/educational_institution_remote_datasource.dart';
import '../../../../../infra/repositories/educational_institution_repository.dart';



class EducationalInstitutionBinding {
  static void dependencies() {
    Get.lazyPut<IEducationalInstitutionRemoteDatasource>(
      () => EducationalInstitutionRemoteDatasource(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut<IEducationalInstitutionRepository>(
      () => EducationalInstitutionRepositoryImpl(
        remoteDatasource: Get.find<IEducationalInstitutionRemoteDatasource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<GetEducationalInstitutions>(
      () => GetEducationalInstitutions(
        repository: Get.find<IEducationalInstitutionRepository>(),
      ),
      fenix: true,
    );
  }
}