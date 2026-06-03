import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../entities/address_api_entity.dart';
import '../../repositories/address_repository.dart';

class GetByZipcode {
   final IAddressRepository repository;
  GetByZipcode({required this.repository});

  Future<Either<Failure,AddressApiEntity>> call(
    String zipCode,
  ) {
    return repository.getByZipCode(zipCode);
  }
}