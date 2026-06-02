import 'dart:convert';
import 'package:nit_sgpi_frontend/domain/entities/consent_term_entity.dart';
import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import 'package:nit_sgpi_frontend/infra/models/consent_term_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../core/network/api_client.dart';

abstract class IConsentTermRemoteDataSource{
  Future<ConsentTermEntity> getConsentTermByIpTypes(int id);
}

class ConsentTermRemoteDatasourceImpl implements IConsentTermRemoteDataSource{
  final ApiClient apiClient;

  ConsentTermRemoteDatasourceImpl(this.apiClient);
  
  @override
  Future<ConsentTermEntity> getConsentTermByIpTypes(int id) async{
    try{
       final response = await apiClient.get(
        "${BaseUrl.urlWithHttp}/consent-term/ip-types/$id",
      );
      if(response.statusCode == 200){
        return ConsentTermModel.fromJson(json.decode(response.body)).toEntity();  
      }else {
        throw ServerException(
          'Erro ${response.statusCode} ao buscar! - Detalhes: ${response.body}',
        );
      }
    } on ServerException {
      rethrow; // 👈 mantém a exception original
    }
    catch (e) {
      throw NetworkException('Erro de conexão com o servidor!');
    }
  }
}