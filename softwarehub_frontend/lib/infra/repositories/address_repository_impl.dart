import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:nit_sgpi_frontend/domain/repositories/address_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/address_remote_datasource.dart';

import '../../domain/core/errors/exceptions.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/address_api_entity.dart';

class AddressRepositoryImpl implements IAddressRepository {
  final IAddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AddressApiEntity>> getByZipCode(String zipCode) async {
    try {
      final result = await remoteDataSource.getByZipCode(zipCode);
      return Right(result);
    } on ClientException catch (e) {
      return Left(ServerFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
}
