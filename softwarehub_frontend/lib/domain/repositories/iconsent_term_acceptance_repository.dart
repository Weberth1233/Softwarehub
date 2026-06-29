import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';
import '../core/repository/generic_repository.dart';
import '../entities/consent_term_acceptance_entity.dart';

abstract class IConsentTermAcceptanceRepository
    extends IGenericPostRepository<ConsentTermAcceptanceEntity, bool> {
  // Future<Either<Failure, bool>> postConsentTermAcceptance(int consentTermId);
  //get_consent_term_was_accepted
  Future<Either<Failure, bool>> getConsentTermWasAccepted(int id);
}
