import 'package:nit_sgpi_frontend/infra/core/mappers/entity_mapper.dart';

import '../../domain/entities/institutional_link_type_entity.dart';

class InstitutionalLinkTypeModel implements EntityMapper<InstitutionalLinkTypeEntity>{
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InstitutionalLinkTypeModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstitutionalLinkTypeModel.fromJson(Map<String, dynamic> json) {
    return InstitutionalLinkTypeModel(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  InstitutionalLinkTypeEntity toEntity() {
    return InstitutionalLinkTypeEntity(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}