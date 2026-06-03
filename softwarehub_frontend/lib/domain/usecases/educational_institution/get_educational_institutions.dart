import '../../entities/educational_institution_entity.dart';
import '../../repositories/ieducational_institution_repository.dart';
import '../generic/get_list_usecase.dart';

class GetEducationalInstitutions extends GetListUsecase<EducationalInstitutionEntity, IEducationalInstitutionRepository>{
  GetEducationalInstitutions({required super.repository});
}