import 'package:nit_sgpi_frontend/domain/entities/external_author/external_author_entity.dart';

class ExternalAuthorModel {
  final int? id;
  final String fullName;
  final String email;
  final String cpf;

  ExternalAuthorModel({this.id, required this.fullName, required this.email, required this.cpf});

   /// Converte JSON -> Model (se você realmente precisar disso)
  factory ExternalAuthorModel.fromJson(Map<String, dynamic> json) {
    return ExternalAuthorModel(
      id: json['id'] ?? '',
      fullName: json['fullName'],
      cpf: json['cpf'],
      email: json['email'],
    );
  }

  /// Converte Model -> JSON (pra API)
  Map<String, dynamic> toJson() {
    return {
      "id": id ?? '',
      "fullName": fullName,
      "cpf":cpf,
      "email": email,
    };
  }

  /// Converte Entity -> Model (pra enviar pra API)
  factory ExternalAuthorModel.fromEntity(ExternalAuthorEntity entity) {
    return ExternalAuthorModel(
      id: entity.id,
      fullName: entity.fullName,
      cpf: entity.cpf,
      email: entity.email,
    );
  }
  
  ExternalAuthorEntity toEntity() {
    return ExternalAuthorEntity(
      id: id,
      fullName: fullName,
      cpf: cpf,
      email: email,
    );
  }
}