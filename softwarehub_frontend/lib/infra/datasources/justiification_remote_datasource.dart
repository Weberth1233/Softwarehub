import 'package:nit_sgpi_frontend/domain/core/errors/exceptions.dart';
import 'package:nit_sgpi_frontend/domain/entities/justification_request_entity.dart';
import 'package:nit_sgpi_frontend/infra/core/network/base_url.dart';
import 'package:nit_sgpi_frontend/infra/models/justification_request_model.dart';
import '../core/network/api_client.dart';
import '../utils/error_formatter.dart';

abstract class IJustificationRemoteDataSource{
  Future<String> postJustification(JustificationRequestEntity justification);
  Future<String> deleteJustification(int idJustification);
  Future<String> putJustificattion(int idJustification, JustificationRequestEntity justification);
}

class JustificationRemoteDatasourceImpl implements IJustificationRemoteDataSource {
  final ApiClient apiClient;

  JustificationRemoteDatasourceImpl(this.apiClient);
  
  @override
  Future<String> postJustification(JustificationRequestEntity justification) async {
    try{
      final model = JustificationRequestModel.fromEntity(justification);

      final response = await apiClient.post("${BaseUrl.urlWithHttp}/justification",
      body: model.toJson(),
      );
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 201) {
        return "Cadastrado com sucesso!";
      } else if (response.statusCode == 422) {
        return response.body;
      } else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
      }
    }on ServerException {
      rethrow; // 👈 mantém a exception original
    }
    catch(e){
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }
  
  @override
  Future<String> deleteJustification(int idJustification) async{
    try{
      final response = await apiClient.delete("${BaseUrl.urlWithHttp}/justification/$idJustification");
      if(response.statusCode == 204){
        return "Removido com sucesso!";
      }else if(response.statusCode == 404){
        return "Não encontrou justificativa na base de dados!";
      }else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));
      }
    }on ServerException {
      rethrow; // 👈 mantém a exception original
    }
    catch(e){
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }
  
  @override
  Future<String> putJustificattion(int idJustification, JustificationRequestEntity justification) async{
   try{
      final model = JustificationRequestModel.fromEntity(justification);

      final response = await apiClient.put("${BaseUrl.urlWithHttp}/justification/$idJustification",
      body: model.toJson(),
      );
      
      if (response.statusCode == 204) {
        return "Atualizo com sucesso!";
      } else if (response.statusCode == 422) {
        return response.body;
      } else {
        throw ServerException(ApiErrorFormatter.formatFromBody(response.body));

        
      }
    }on ServerException {
      rethrow; // 👈 mantém a exception original
    }
    catch(e){
      print(e);
      throw NetworkException("Erro de conexão com o servidor!");
    }
  }
}