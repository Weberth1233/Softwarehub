import '../../entities/process/process_request_entity.dart';
import '../../repositories/iprocess_repository.dart';
import '../generic/generic_usecases.dart';

class PutProcess
    extends PutUsecase<ProcessRequestEntity, String, IProcessRepository> {
  PutProcess({required super.repository});
}
