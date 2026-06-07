import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/educational_institution_entity.dart';
import '../../domain/repositories/ieducational_institution_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/educational_institution_remote_datasource.dart'
    show IEducationalInstitutionRemoteDatasource;

class EducationalInstitutionRepositoryImpl extends BaseRepository
    implements IEducationalInstitutionRepository {
  final IEducationalInstitutionRemoteDatasource remoteDataSource;

  EducationalInstitutionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EducationalInstitutionEntity>>> getList() {
    return handleRequest(() {
      return remoteDataSource.getList();
    });
  }
}
