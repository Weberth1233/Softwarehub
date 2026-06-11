
import '../core/repository/generic_repository.dart';
import '../entities/process/process_royalty_distribution_request_entity.dart';

abstract class IProcessRoyaltyDistributionRepository implements IGenericPostRepository<ProcessRoyaltyDistributionRequestEntity, String>, IGenericPutRepository<ProcessRoyaltyDistributionRequestEntity, String>{}