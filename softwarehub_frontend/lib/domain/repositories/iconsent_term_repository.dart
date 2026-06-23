import 'package:nit_sgpi_frontend/domain/core/repository/generic_repository.dart';
import 'package:nit_sgpi_frontend/domain/entities/consent_term_entity.dart';

abstract class IConsentTermRepository extends IGenericGetByIdRepository<ConsentTermEntity>{
  // Future<Either<Failure, ConsentTermEntity>> getConsentTermByIpTypes(int id);
}