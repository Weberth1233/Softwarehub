import '../../entities/process/process_request_entity.dart';
import '../../repositories/iprocess_repository.dart';
import '../generic/generic_usecases.dart';

class PostProcess
    extends PostUsecase<ProcessRequestEntity, int, IProcessRepository> {
  PostProcess({required super.repository});
}
