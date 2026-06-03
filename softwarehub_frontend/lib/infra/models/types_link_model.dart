import '../../domain/entities/types_link_entity.dart';

class TypesLinkModel {
  final int? id;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  TypesLinkModel({
    this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory TypesLinkModel.fromJson(Map<String, dynamic> json) {
    return TypesLinkModel(
      id: json['id'],
      name: json['name'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  factory TypesLinkModel.fromEntity(TypesLinkEntity entity) {
    return TypesLinkModel(
      id: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TypesLinkEntity toEntity() {
    return TypesLinkEntity(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}