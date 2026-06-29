import 'package:nit_sgpi_frontend/infra/core/datasources/igeneric_remote_datasource.dart';
import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/entities/consent_term_acceptance_entity.dart';
import '../core/network/api_client.dart';
import '../core/network/remote_datasource_helper.dart';
import '../models/consent_term_acceptance_model.dart';

abstract class IConsentTermAcceptanceRemoteDataSource
    implements IGenericPostRemoteDatasource<ConsentTermAcceptanceEntity, bool> {
  // Future<bool> postConsentTermAcceptance(int consentTermId);
  Future<bool> getConsentTermWasAccepted(int id);
}

class ConsentTermAcceptanceRemoteDataSourceImpl
    implements IConsentTermAcceptanceRemoteDataSource {
  final ApiClient apiClient;
  final RemoteDatasourceHelper helper;

  ConsentTermAcceptanceRemoteDataSourceImpl(this.apiClient)
    : helper = RemoteDatasourceHelper(apiClient);

  @override
  Future<bool> post(ConsentTermAcceptanceEntity entity) async {
    // final uri = Uri.http(BaseUrl.url, "/consent-term-acceptance");
    // final model = ConsentTermAcceptanceModel.fromEntity(entity);
     try{
     final response = await apiClient.post(
      "${BaseUrl.urlWithHttp}/consent-term-acceptance",
      body: {
        'consentTermId': entity.consentTermId
      }
    );
    if(response.statusCode == 201){
      return true;
    }else {
      throw ServerException(
        'Erro ${response.statusCode} ao buscar! - Detalhes: ${response.body}',
      );
    }
  } on ServerException {
    rethrow;
  }
  catch (e) {
    throw NetworkException('Erro de conexão com o servidor!');
  }


    // return helper.post<bool>(
    //   url: uri.toString(),
    //   body: model.toJson(),
    //   onSuccess: (responseBody) {
    //     if (responseBody is bool) {
    //       return responseBody;
    //     }
    //     return responseBody;
    //   },
    // );
  }
  // try{
  //    final response = await apiClient.post(
  //     "${BaseUrl.urlWithHttp}/consent-term-acceptance",
  //     body: {
  //       'consentTermId': consentTermId
  //     }
  //   );
  //   if(response.statusCode == 201){
  //     return true;
  //   }else {
  //     throw ServerException(
  //       'Erro ${response.statusCode} ao buscar! - Detalhes: ${response.body}',
  //     );
  //   }
  // } on ServerException {
  //   rethrow;
  // }
  // catch (e) {
  //   throw NetworkException('Erro de conexão com o servidor!');
  // }

  @override
  Future<bool> getConsentTermWasAccepted(int id) async {
    try {
      final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/consent-term-acceptance/consert-term/$id",
      );
      if (response.statusCode == 200) {
        bool result = bool.parse(response.body);
        return result;
      } else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}
