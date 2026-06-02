import 'package:dartz/dartz.dart';
import '../core/errors/failures.dart';

abstract class IConsentTermAcceptanceRepository {
  Future<Either<Failure, bool>> postConsentTermAcceptance(int consentTermId);
  //get_consent_term_was_accepted
  Future<Either<Failure, bool>> getConsentTermWasAccepted(int id);
}