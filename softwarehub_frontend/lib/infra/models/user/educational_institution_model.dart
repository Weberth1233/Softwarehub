import '../../../domain/entities/user/educational_institution_entity.dart';

class EducationalInstitutionModel {
  final int? id;
  final String name;
  final String cnpj;
  final bool active;
  final String institutionType;
  final String? createdAt;
  final String? updatedAt;

  EducationalInstitutionModel({
    this.id,
    required this.name,
    required this.cnpj,
    required this.active,
    required this.institutionType,
    this.createdAt,
    this.updatedAt,
  });

  factory EducationalInstitutionModel.fromJson(Map<String, dynamic> json) {
    return EducationalInstitutionModel(
      id: json['id'],
      name: json['name'] ?? '',
      cnpj: json['cnpj'] ?? '',
      active: json['active'] ?? false,
      institutionType: json['institutionType'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "cnpj": cnpj,
      "active": active,
      "institutionType": institutionType,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory EducationalInstitutionModel.fromEntity(
    EducationalInstitutionEntity entity,
  ) {
    return EducationalInstitutionModel(
      id: entity.id,
      name: entity.name,
      cnpj: entity.cnpj,
      active: entity.active,
      institutionType: entity.institutionType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  EducationalInstitutionEntity toEntity() {
    return EducationalInstitutionEntity(
      id: id,
      name: name,
      cnpj: cnpj,
      active: active,
      institutionType: institutionType,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}