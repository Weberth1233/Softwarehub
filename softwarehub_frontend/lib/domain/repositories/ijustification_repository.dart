import '../core/repository/generic_repository.dart';
import '../entities/justification/justification_attachment_file_entity.dart';
import '../entities/justification/justification_request_entity.dart';

abstract class IJustificationRepository
    implements
        IGenericPostRepository<JustificationRequestEntity, String>,
        IGenericPutRepository<JustificationRequestEntity, String>,
        IGenericGetByIdRepository<JustificationAttachmentFileEntity>,
        IGenericDeleteRepository<String> {
 
}
