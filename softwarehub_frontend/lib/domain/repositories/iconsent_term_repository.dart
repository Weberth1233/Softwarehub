import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/consent_term_entity.dart';

import '../core/errors/failures.dart';

abstract class IConsentTermRepository {
  Future<Either<Failure, ConsentTermEntity>> getConsentTermByIpTypes(int id);
}