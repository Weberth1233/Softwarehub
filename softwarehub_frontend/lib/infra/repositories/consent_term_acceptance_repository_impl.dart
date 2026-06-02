import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/repositories/iconsent_term_acceptance_repository.dart';
import '../datasources/consent_term_acceptance_remote_datasource.dart';

class ConsentTermAcceptanceRepositoryImpl implements IConsentTermAcceptanceRepository{
  final IConsentTermAcceptanceRemoteDataSource remoteDataSource;
  ConsentTermAcceptanceRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, bool>> getConsentTermWasAccepted(int id) async{
    try {
      final result = await remoteDataSource.getConsentTermWasAccepted(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
  
  @override
  Future<Either<Failure, bool>> postConsentTermAcceptance(int consentTermId) async{
    try {
      final result = await remoteDataSource.postConsentTermAcceptance(consentTermId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
}