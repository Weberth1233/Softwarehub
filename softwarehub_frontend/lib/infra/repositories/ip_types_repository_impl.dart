import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/core/errors/failures.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_types/ip_type_entity.dart';
import 'package:nit_sgpi_frontend/domain/repositories/iip_types_repository.dart';
import 'package:nit_sgpi_frontend/infra/datasources/ip_types_remote_datasource.dart';
import '../../domain/core/errors/exceptions.dart';

class IpTypesRepositoryImpl implements IipTypesRepository{
  final IIpTypesRemoteDataSource remoteDataSource;

  IpTypesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<IpTypeEntity>>> getIpTypes() async{
    try {
      final result = await remoteDataSource.getIpTypes();

      final resultEntityList = result.map((e) => e.toEntity()).toList();

      return Right(resultEntityList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
}