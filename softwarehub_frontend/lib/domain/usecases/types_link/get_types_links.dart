import 'package:nit_sgpi_frontend/domain/entities/types_link_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/itypes_link_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/generic/generic_usecases.dart';

class GetTypesLinks extends GetListUsecase<TypesLinkEntity, ITypesLinkRepository>{
  GetTypesLinks({required super.repository});
}