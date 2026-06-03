import '../../entities/ip_type_entity.dart';
import '../../repositories/iip_types_repository.dart';
import '../generic/get_list_usecase.dart';

class GetIpTypes extends GetListUsecase<IpTypeEntity, IIpTypesRepository> {
  GetIpTypes({required super.repository});
}