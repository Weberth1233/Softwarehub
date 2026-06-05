import '../../entities/nice_classification_entity.dart';
import '../../repositories/inice_classification_repository.dart';
import '../generic/get_list_usecase.dart';

class GetNiceClassification extends GetListUsecase<NiceClassificationEntity, INiceClassificationRepository>{
  GetNiceClassification({required super.repository});
}