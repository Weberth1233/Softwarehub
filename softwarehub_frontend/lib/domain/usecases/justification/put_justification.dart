import '../../entities/justification/justification_request_entity.dart';
import '../../repositories/ijustification_repository.dart';
import '../generic/generic_usecases.dart';

class PutJustification
    extends
        PutUsecase<
          JustificationRequestEntity,
          String,
          IJustificationRepository
        > {
  PutJustification({required super.repository});
}
