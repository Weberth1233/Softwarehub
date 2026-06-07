
import '../../domain/entities/educational_institution_entity.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/educational_institution_model.dart';
import '../core/datasources/igeneric_remote_datasource.dart';

abstract class IEducationalInstitutionRemoteDatasource extends IGenericListRemoteDatasource<EducationalInstitutionEntity>{
}

class EducationalInstitutionRemoteDatasource
    implements IEducationalInstitutionRemoteDatasource {
  final RemoteDatasourceHelper helper;

  EducationalInstitutionRemoteDatasource(ApiClient apiClient)
      : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<List<EducationalInstitutionEntity>> getList() {
    return helper.getList<EducationalInstitutionEntity>(
      url: "${BaseUrl.urlWithHttp}/educational-institution",
      authenticated: false,
      fromJson: (json) {
        return EducationalInstitutionModel.fromJson(json).toEntity();
      },
      errorMessage: 'Erro ao buscar instituições educacionais!',
    );
  }
}