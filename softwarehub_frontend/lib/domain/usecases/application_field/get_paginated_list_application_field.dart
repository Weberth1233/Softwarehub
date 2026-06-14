import '../../entities/application_field_entity.dart';
import '../../repositories/iapplication_field_repository.dart';
import '../generic/generic_usecases.dart';

class GetPaginatedListApplicationField extends GetPaginatedList<ApplicationFieldEntity, IApplicationFieldRepository>{
  GetPaginatedListApplicationField({required super.repository}); 
}