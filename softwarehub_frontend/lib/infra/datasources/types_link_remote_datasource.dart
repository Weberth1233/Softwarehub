
import '../../domain/entities/types_link_entity.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/types_link_model.dart';
import 'igeneric_remote_datasource.dart';

abstract class ITypesLinkRemoteDatasource extends IGenericRemoteDatasource<TypesLinkEntity>{}

class TypesLinkRemoteDatasource implements ITypesLinkRemoteDatasource {
  final RemoteDatasourceHelper helper;

  TypesLinkRemoteDatasource(ApiClient apiClient)
      : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<List<TypesLinkEntity>> getList() async {
    return helper.getList<TypesLinkEntity>(
      url: "${BaseUrl.urlWithHttp}/types-link",
      fromJson: (json) {
        return TypesLinkModel.fromJson(json).toEntity();
      },
      authenticated: false,
      errorMessage: 'Erro ao buscar vínculo!',
    );
  }
}