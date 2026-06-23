import '../../domain/entities/consent_term_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/consent_term_model.dart';

abstract class IConsentTermRemoteDataSource
    implements IGenericGetByIdRemoteDatasource<ConsentTermEntity> {
}

class ConsentTermRemoteDatasourceImpl extends IConsentTermRemoteDataSource {
  final RemoteDatasourceHelper helper;

  ConsentTermRemoteDatasourceImpl(ApiClient apiClient)
    : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<ConsentTermEntity> getById(int id) async {
    final uri = Uri.http(BaseUrl.url,'/consent-term/ip-types/$id');
    return helper.getById<ConsentTermEntity, ConsentTermModel>(
      url: uri.toString(),
      fromJson: ConsentTermModel.fromJson,
      toEntity: (model) => model.toEntity(),
    );
  }

  
}
