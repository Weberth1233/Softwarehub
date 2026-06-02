import 'package:dartz/dartz.dart';

import '../core/errors/failures.dart';
import '../repositories/iconsent_term_acceptance_repository.dart';

class GetConsentTermWasAccepted {
  final IConsentTermAcceptanceRepository repository;

  GetConsentTermWasAccepted({required this.repository});

   Future<Either<Failure, bool>> call(int id) async{
    final result = await repository.getConsentTermWasAccepted(id);
    return result;
  }
}