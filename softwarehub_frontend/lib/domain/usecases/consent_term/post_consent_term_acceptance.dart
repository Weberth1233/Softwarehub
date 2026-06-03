import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iconsent_term_acceptance_repository.dart';

import '../../core/errors/failures.dart';

class PostConsentTermAcceptance {
  final IConsentTermAcceptanceRepository repository;

  PostConsentTermAcceptance({required this.repository});

   Future<Either<Failure, bool>> call(int consentTermId) async{
    final result = await repository.postConsentTermAcceptance(consentTermId);
    return result;
  }
}