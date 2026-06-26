import '../../entities/process/process_response_entity.dart';
import '../../repositories/iprocess_repository.dart';
import '../generic/generic_usecases.dart';

class GetProcessById
    extends GetByIdUsecase<ProcessResponseEntity, IProcessRepository> {
  GetProcessById({required super.repository});
}
