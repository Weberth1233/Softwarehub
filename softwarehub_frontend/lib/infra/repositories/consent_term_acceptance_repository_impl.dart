import 'package:dartz/dartz.dart';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/consent_term_acceptance_entity.dart';
import '../../domain/repositories/iconsent_term_acceptance_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/consent_term_acceptance_remote_datasource.dart';

class ConsentTermAcceptanceRepositoryImpl extends BaseRepository implements IConsentTermAcceptanceRepository{
  final IConsentTermAcceptanceRemoteDataSource remoteDataSource;
  ConsentTermAcceptanceRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, bool>> getConsentTermWasAccepted(int id) async{
    return handleRequest(() {
      return remoteDataSource.getConsentTermWasAccepted(id);
    });
  }

  @override
  Future<Either<Failure, bool>> post(ConsentTermAcceptanceEntity entity) {
    return handleRequest(() {
      return remoteDataSource.post(entity);
    });
  }
  
  // @override
  // Future<Either<Failure, bool>> post(int consentTermId) async{
  //   try {
  //     final result = await remoteDataSource.post(consentTermId);
  //     return Right(result);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message));
  //   } on NetworkException catch (e) {
  //     return Left(NetworkFailure(e.message));
  //   } catch (e) {
  //     return Left(ServerFailure("Erro inesperado!"));
  //   }
  // }
}