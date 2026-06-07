import '../../domain/entities/ip_type_entity.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/ip_types/ip_types_model.dart';
import '../core/datasources/igeneric_remote_datasource.dart';

abstract class IIpTypesRemoteDataSource extends IGenericListRemoteDatasource<IpTypeEntity>{
}

class IpTypesRemoteDataSourceImpl implements IIpTypesRemoteDataSource {
  final RemoteDatasourceHelper helper;

  IpTypesRemoteDataSourceImpl(ApiClient apiClient)
      : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<List<IpTypeEntity>> getList() {
    return helper.getList<IpTypeEntity>(
      url: "${BaseUrl.urlWithHttp}/ip_types",
      fromJson: (json){
        return IpTypeModel.fromJson(json).toEntity();
      },
      errorMessage: 'Erro ao buscar tipos de propriedade intelectual!',
    );
  }
}