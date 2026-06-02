import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';

abstract class IConsentTermAcceptanceRemoteDataSource{
  Future<bool> postConsentTermAcceptance(int consentTermId);
  Future<bool> getConsentTermWasAccepted(int id);
}

class ConsentTermAcceptanceRemoteDataSourceImpl implements IConsentTermAcceptanceRemoteDataSource{
  final ApiClient apiClient;

  ConsentTermAcceptanceRemoteDataSourceImpl(this.apiClient);
  
  @override
  Future<bool> postConsentTermAcceptance(int consentTermId) async{
    try{
       final response = await apiClient.post(
        "${BaseUrl.urlWithHttp}/consent-term-acceptance",
        body: {
          'consentTermId': consentTermId
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
  }
  
  @override
  Future<bool> getConsentTermWasAccepted(int id) async{
    try{
       final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/consent-term-acceptance/consert-term/$id",
      );
      if(response.statusCode == 200){
        bool result = bool.parse(response.body);
        return result;
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
  }
}