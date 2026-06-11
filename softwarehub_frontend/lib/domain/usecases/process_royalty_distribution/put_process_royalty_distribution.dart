import 'package:nit_sgpi_frontend/domain/entities/process/process_royalty_distribution_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iprocess_royalty_distribution_repository.dart';
import 'package:nit_sgpi_frontend/domain/usecases/generic/generic_usecases.dart';

class PutProcessRoyaltyDistribution extends PutUsecase<ProcessRoyaltyDistributionRequestEntity, String, IProcessRoyaltyDistributionRepository>{
  PutProcessRoyaltyDistribution({required super.repository});
}