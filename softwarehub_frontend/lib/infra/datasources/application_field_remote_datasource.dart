import '../../domain/entities/application_field_entity.dart';
import '../../domain/entities/paged_result_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/application_field_model.dart';

abstract class IApplicationFieldRemoteDataSource
    implements IGenericPaginatedList<ApplicationFieldEntity> {}

class ApplicationFieldRemoteDatasource
    extends IApplicationFieldRemoteDataSource {
  final RemoteDatasourceHelper helper;

  ApplicationFieldRemoteDatasource(ApiClient apiClient)
      : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<PagedResultEntity<ApplicationFieldEntity>> getPaginatedList(
    Map<String, String> values,
  ) async {
    final uri = Uri.http(
      BaseUrl.url,
      '/application-field/search',
      values,
    );

    return helper
        .getPagedList<ApplicationFieldModel, ApplicationFieldEntity>(
      url: uri.toString(),
      fromJson: ApplicationFieldModel.fromJson,
      toEntity: (model) => model.toEntity(),
      errorMessage: 'Erro ao buscar campos de aplicação!',
    );
  }
  
 
}