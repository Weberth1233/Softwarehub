import '../../entities/consent_term_acceptance_entity.dart';
import '../../repositories/iconsent_term_acceptance_repository.dart';
import '../generic/generic_usecases.dart';

class PostConsentTermAcceptance
    extends
        PostUsecase<
          ConsentTermAcceptanceEntity,
          bool,
          IConsentTermAcceptanceRepository
        > {
  PostConsentTermAcceptance({required super.repository});
  // final IConsentTermAcceptanceRepository repository;

  // PostConsentTermAcceptance({required this.repository});

  //  Future<Either<Failure, bool>> call(int consentTermId) async{
  //   final result = await repository.postConsentTermAcceptance(consentTermId);
  //   return result;
  // }
}
