import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/consent_term_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iconsent_term_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/consent_term_remote_datasource.dart';
import '../../domain/core/errors/exceptions.dart';

class ConsentTermRepositoryImpl implements IConsentTermRepository{
  final IConsentTermRemoteDataSource remoteDataSource;

  ConsentTermRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ConsentTermEntity>> getConsentTermByIpTypes(int id) async{
   try {
      final result = await remoteDataSource.getConsentTermByIpTypes(id);
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