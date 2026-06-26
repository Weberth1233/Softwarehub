import '../../entities/justification/justification_attachment_file_entity.dart'
    show JustificationAttachmentFileEntity;
import '../../repositories/ijustification_repository.dart';
import '../generic/generic_usecases.dart';

class GetAttachmentFile
    extends
        GetByIdUsecase<
          JustificationAttachmentFileEntity,
          IJustificationRepository
        > {
  GetAttachmentFile({required super.repository});
}
