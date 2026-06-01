import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/entities/consent_term_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iconsent_term_repository.dart';

import '../core/errors/failures.dart';

class GetConsentTermByIpTypes {
    final IConsentTermRepository repository;

  GetConsentTermByIpTypes({required this.repository});

  Future<Either<Failure, ConsentTermEntity>> call(
    int id
  ) {
    return repository.getConsentTermByIpTypes(id);
  }

}