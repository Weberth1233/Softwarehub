import '../../domain/entities/educational_institution_entity.dart';
import '../../domain/repositories/ieducational_institution_repository.dart';
import '../datasources/educational_institution_remote_datasource.dart'
    show IEducationalInstitutionRemoteDatasource;
import 'generic_repository_impl.dart';

class EducationalInstitutionRepositoryImpl
    extends GenericRepositoryImpl<EducationalInstitutionEntity>
    
    implements IEducationalInstitutionRepository {
  EducationalInstitutionRepositoryImpl({

    required IEducationalInstitutionRemoteDatasource remoteDatasource,
  }) : super(remoteDatasource: remoteDatasource);
}
