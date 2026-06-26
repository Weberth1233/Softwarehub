import '../../entities/process/process_response_entity.dart';
import '../../repositories/iprocess_repository.dart';
import '../generic/generic_usecases.dart';


class GetProcesses extends GetPaginatedList<ProcessResponseEntity, IProcessRepository>{
  GetProcesses({required super.repository});
  

}
