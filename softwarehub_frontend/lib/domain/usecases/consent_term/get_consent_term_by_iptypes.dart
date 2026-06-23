import '../../entities/consent_term_entity.dart';
import '../../repositories/iconsent_term_repository.dart';
import '../generic/generic_usecases.dart';

class GetConsentTermByIpTypes extends GetByIdUsecase<ConsentTermEntity, IConsentTermRepository>{
  GetConsentTermByIpTypes({required super.repository});
  
}
