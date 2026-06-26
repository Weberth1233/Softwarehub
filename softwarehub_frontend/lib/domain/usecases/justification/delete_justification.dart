import '../../repositories/ijustification_repository.dart';
import '../generic/generic_usecases.dart';

class DeleteJustification
    extends DeleteUsecase<String, IJustificationRepository> {
  DeleteJustification({required super.repository});
}
