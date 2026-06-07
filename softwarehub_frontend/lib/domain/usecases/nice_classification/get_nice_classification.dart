import '../../entities/nice_classification_entity.dart';
import '../../repositories/inice_classification_repository.dart';
import '../generic/generic_usecases.dart';

class GetNiceClassification extends GetListUsecase<NiceClassificationEntity, INiceClassificationRepository>{
  GetNiceClassification({required super.repository});
}