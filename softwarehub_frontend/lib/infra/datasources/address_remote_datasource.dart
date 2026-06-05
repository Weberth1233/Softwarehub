import 'dart:convert';
import 'package:http/http.dart';
import 'package:nit_sgpi_frontend/infra/core/network/api_client.dart';
import 'package:nit_sgpi_frontend/infra/models/address_api_model.dart';
import '../../domain/core/errors/exceptions.dart';
import '../../domain/entities/address_api_entity.dart';

abstract class IAddressRemoteDataSource {
  Future<AddressApiEntity> getByZipCode(String zipCode);
}

class AddressRemoteDataSource implements IAddressRemoteDataSource {
  final ApiClient apiClient;

  AddressRemoteDataSource(this.apiClient);

  @override
  Future<AddressApiEntity> getByZipCode(String zipCode) async {
    try {
      final response = await apiClient.get(
        "https://viacep.com.br/ws/$zipCode/json/",
        authenticated: false,
      );
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        AddressApiEntity addressApiEntity = AddressApiModel.fromJson(
          json,
        ).toEntity();
        return addressApiEntity;
      } else {
        throw ClientException('Detalhes: ${response.body}');
      }
    } on ServerException {
      rethrow;
    } on ClientException {
      rethrow;
    } catch (e) {
      print(e);
      throw NetworkException('Erro de conexão com o servidor!$e');
    }
  }
}
