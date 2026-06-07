import '../../domain/entities/nice_classification_entity.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/nice_classification_model.dart';
import '../core/datasources/igeneric_remote_datasource.dart';

abstract class INiceClassificationRemoteDatasource extends IGenericListRemoteDatasource<NiceClassificationEntity>{}

class NiceClassificationRemoteDatasourceImpl implements INiceClassificationRemoteDatasource {
  final RemoteDatasourceHelper helper;

  NiceClassificationRemoteDatasourceImpl(ApiClient apiClient)
      : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<List<NiceClassificationEntity>> getList() async {
    return helper.getList<NiceClassificationEntity>(
      url: "${BaseUrl.urlWithHttp}/nice-classification",
      fromJson: (json) {
        return NiceClassificationModel.fromJson(json).toEntity();
      },
      errorMessage: 'Erro ao buscar vínculo!',
    );
  }
}