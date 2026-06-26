import '../../entities/justification/justification_request_entity.dart';
import '../../repositories/ijustification_repository.dart';
import '../generic/generic_usecases.dart';

class PostJustification
    extends
        PostUsecase<
          JustificationRequestEntity,
          String,
          IJustificationRepository
        > {
  PostJustification({required super.repository});
}
