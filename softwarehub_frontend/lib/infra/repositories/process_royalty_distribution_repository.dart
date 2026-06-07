import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_royalty_distribution_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iprocess_royalty_distribution_repository.dart';
import 'package:nit_sgpi_frontend/infra/core/repositories/base_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/process_royalty_distribution_remote_datasource.dart';

class ProcessRoyaltyDistributionRepository extends BaseRepository implements IProcessRoyaltyDistributionRepository{
  
  final IProcessRoyaltyDistributionRemoteDatasource remoteDataSource;

  ProcessRoyaltyDistributionRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> post(ProcessRoyaltyDistributionRequestEntity entity) {
    return handleRequest(() {
      return remoteDataSource.post(entity);      
    },);  
  }
}