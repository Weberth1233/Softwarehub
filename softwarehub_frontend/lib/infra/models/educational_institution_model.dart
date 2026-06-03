import '../../domain/entities/educational_institution_entity.dart';
import '../core/mappers/entity_mapper.dart';

class EducationalInstitutionModel implements EntityMapper<EducationalInstitutionEntity>{
  final int id;
  final String name;
  final String cnpj;
  final bool active;
  final String institutionType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EducationalInstitutionModel({
    required this.id,
    required this.name,
    required this.cnpj,
    required this.active,
    required this.institutionType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EducationalInstitutionModel.fromJson(Map<String, dynamic> json) {
    return EducationalInstitutionModel(
      id: json['id'],
      name: json['name'],
      cnpj: json['cnpj'],
      active: json['active'],
      institutionType: json['institutionType'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  factory EducationalInstitutionModel.fromEntity(EducationalInstitutionEntity entity) {
    return EducationalInstitutionModel(
      id: entity.id,
      name:  entity.name,
      cnpj: entity.cnpj,
      active: entity.active,
      institutionType: entity.institutionType,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cnpj': cnpj,
      'active': active,
      'institutionType': institutionType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
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