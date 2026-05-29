import '../../../domain/entities/ip_types/ip_type_entity.dart';

class IpTypeFieldOptionModel {
  final String label;
  final String value;

  IpTypeFieldOptionModel({
    required this.label,
    required this.value,
  });

  factory IpTypeFieldOptionModel.fromJson(Map<String, dynamic> json) {
    return IpTypeFieldOptionModel(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
    );
  }

  factory IpTypeFieldOptionModel.fromEntity(
    IpTypeFieldOptionEntity entity,
  ) {
    return IpTypeFieldOptionModel(
      label: entity.label,
      value: entity.value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }

  IpTypeFieldOptionEntity toEntity() {
    return IpTypeFieldOptionEntity(
      label: label,
      value: value,
    );
  }
}