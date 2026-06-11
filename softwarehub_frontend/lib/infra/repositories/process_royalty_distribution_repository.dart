import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/process/process_royalty_distribution_request_entity.dart' show ProcessRoyaltyDistributionRequestEntity;
import '../../domain/repositories/iprocess_royalty_distribution_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/process_royalty_distribution_remote_datasource.dart';

class ProcessRoyaltyDistributionRepository extends BaseRepository implements IProcessRoyaltyDistributionRepository{
  final IProcessRoyaltyDistributionRemoteDatasource remoteDataSource;

  ProcessRoyaltyDistributionRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> post(ProcessRoyaltyDistributionRequestEntity entity) {
    return handleRequest(() {
      return remoteDataSource.post(entity);      
    },);  
  }
  
  @override
  Future<Either<Failure, String>> put(int id, ProcessRoyaltyDistributionRequestEntity entity) {
   return handleRequest(() {
      return remoteDataSource.put(id,entity);      
    },);  
  }
}