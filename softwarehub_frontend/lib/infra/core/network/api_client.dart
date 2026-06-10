import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../presentation/shared/controller/auth_controller.dart';

class ApiClient {
  final http.Client client;

  ApiClient(this.client);

  Map<String, String> _headers({bool authenticated = true}) {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (!authenticated) {
      return headers;
    }

    final authController = Get.find<AuthController>();
    final token = authController.token;

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> _handleResponse(
    http.Response response, {
    bool authenticated = true,
  }) async {
    if (authenticated && response.statusCode == 401) {
      await Get.find<AuthController>().logout();
    }

    return response;
  }

  Future<http.Response> get(String url, {bool authenticated = true}) async {
    final response = await client.get(
      Uri.parse(url),
      headers: _headers(authenticated: authenticated),
    );

    return _handleResponse(response, authenticated: authenticated);
  }

    Future<http.Response> getFile(String url, {bool authenticated = true}) async {
    final response = await client.get(
      Uri.parse(url),
      headers: _headers(authenticated: authenticated),
    );

    return _handleResponse(response, authenticated: authenticated);
  }



  Future<http.Response> post(
    String url, {
    Object? body,
    bool authenticated = true,
  }) async {
    final response = await client.post(
      Uri.parse(url),
      headers: _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response, authenticated: authenticated);
  }

  Future<http.Response> patch(
    String url, {
    Object? body,
    bool authenticated = true,
  }) async {
    final response = await client.patch(
      Uri.parse(url),
      headers: _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response, authenticated: authenticated);
  }

  Future<http.Response> put(
    String url, {
    Object? body,
    bool authenticated = true,
  }) async {
    final response = await client.put(
      Uri.parse(url),
      headers: _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response, authenticated: authenticated);
  }

  Future<http.Response> delete(
    String url, {
    Object? body,
    bool authenticated = true,
  }) async {
    final response = await client.delete(
      Uri.parse(url),
      headers: _headers(authenticated: authenticated),
      body: body == null ? null : jsonEncode(body),
    );

    return _handleResponse(response, authenticated: authenticated);
  }

  Future<http.Response> upload(
    String url, {
    String? filePath,
    List<int>? fileBytes,
    required String fileName,
    String fieldName = 'file',
    bool authenticated = true,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (authenticated) {
      final authController = Get.find<AuthController>();
      final token = authController.token;

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    http.MultipartFile multipartFile;

    if (kIsWeb) {
      if (fileBytes == null) {
        throw Exception("Na Web, os bytes do arquivo são obrigatórios");
      }

      multipartFile = http.MultipartFile.fromBytes(
        fieldName,
        fileBytes,
        filename: fileName,
      );
    } else {
      if (filePath == null) {
        throw Exception("No Mobile, o path é obrigatório");
      }

      multipartFile = await http.MultipartFile.fromPath(
        fieldName,
        filePath,
        filename: fileName,
      );
    }

    request.files.add(multipartFile);

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, authenticated: authenticated);
  }

  Future<http.Response> multipartPost(
    String url, {
    Map<String, String>? fields,
    String? filePath,
    List<int>? fileBytes,
    String? fileName,
    String fieldName = 'file',
    bool authenticated = true,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    if (authenticated) {
      final authController = Get.find<AuthController>();
      final token = authController.token;

      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    if (fields != null && fields.isNotEmpty) {
      request.fields.addAll(fields);
    }

    if (fileName != null && fileName.isNotEmpty) {
      http.MultipartFile multipartFile;

      if (kIsWeb) {
        if (fileBytes == null) {
          throw Exception("Na Web, os bytes do arquivo são obrigatórios");
        }

        multipartFile = http.MultipartFile.fromBytes(
          fieldName,
          fileBytes,
          filename: fileName,
        );
      } else {
        if (filePath == null) {
          throw Exception("No Mobile, o path é obrigatório");
        }

        multipartFile = await http.MultipartFile.fromPath(
          fieldName,
          filePath,
          filename: fileName,
        );
      }

      request.files.add(multipartFile);
    }

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    return _handleResponse(response, authenticated: authenticated);
  }
}
