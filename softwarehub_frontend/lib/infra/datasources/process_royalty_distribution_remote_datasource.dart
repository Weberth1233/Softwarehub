import '../../domain/entities/process/process_royalty_distribution_request_entity.dart';
import '../core/datasources/igeneric_remote_datasource.dart';
import '../core/network/api_client.dart';
import '../core/network/base_url.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/process/process_royalty_distribution_request_model.dart';

abstract class IProcessRoyaltyDistributionRemoteDatasource
    implements
        IGenericPostRemoteDatasource<ProcessRoyaltyDistributionRequestEntity> {}

class ProcessRoyaltyDistributionRemoteDatasource
    implements IProcessRoyaltyDistributionRemoteDatasource {
  final RemoteDatasourceHelper helper;

  ProcessRoyaltyDistributionRemoteDatasource(ApiClient apiClient)
    : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<String> post(ProcessRoyaltyDistributionRequestEntity entity) {
    final model = ProcessRoyaltyDistributionRequestModel.fromEntity(entity);

    return helper.post<String>(
      url: "${BaseUrl.urlWithHttp}/process-royalty-distribution",
      body: model.toJson(),
      successStatusCodes: const [201],
      onSuccess: (responseBody) {
        return "Distribuição de cotas cadastrada com sucesso!";
      },
    );
  }
}
