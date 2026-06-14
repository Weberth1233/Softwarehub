import '../../domain/entities/application_field_entity.dart';

class ApplicationFieldModel {
  final int id;
  final String code;
  final String name;
  final String description;
  final int applicationAreaId;
  final String applicationAreaCode;
  final String applicationAreaName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApplicationFieldModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.applicationAreaId,
    required this.applicationAreaCode,
    required this.applicationAreaName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ApplicationFieldModel.fromJson(Map<String, dynamic> json) {
    return ApplicationFieldModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      applicationAreaId: json['applicationAreaId'],
      applicationAreaCode: json['applicationAreaCode'],
      applicationAreaName: json['applicationAreaName'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'applicationAreaId': applicationAreaId,
      'applicationAreaCode': applicationAreaCode,
      'applicationAreaName': applicationAreaName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ApplicationFieldEntity toEntity() {
    return ApplicationFieldEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      applicationAreaId: applicationAreaId,
      applicationAreaCode: applicationAreaCode,
      applicationAreaName: applicationAreaName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ApplicationFieldModel.fromEntity(ApplicationFieldEntity entity) {
    return ApplicationFieldModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      applicationAreaId: entity.applicationAreaId,
      applicationAreaCode: entity.applicationAreaCode,
      applicationAreaName: entity.applicationAreaName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}