import '../../domain/entities/nice_classification_entity.dart';

class NiceClassificationModel {
  final int code;
  final String name;
  final String type;
  final String description;

  NiceClassificationModel({
    required this.code,
    required this.name,
    required this.type,
    required this.description,
  });

  factory NiceClassificationModel.fromJson(Map<String, dynamic> json) {
    return NiceClassificationModel(
      code: json['code'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
    );
  }

  factory NiceClassificationModel.empty() {
    return NiceClassificationModel(
      code: 0,
      name: '',
      type: '',
      description: 'Ainda não foi classificado o processo',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'type': type,
      'description': description,
    };
  }

  NiceClassificationEntity toEntity() {
    return NiceClassificationEntity(
      code: code,
      name: name,
      type: type,
      description: description,
    );
  }

  factory NiceClassificationModel.fromEntity(
    NiceClassificationEntity entity,
  ) {
    return NiceClassificationModel(
      code: entity.code,
      name: entity.name,
      type: entity.type,
      description: entity.description,
    );
  }
}