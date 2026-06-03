import '../../../domain/entities/ip_type_entity.dart';

class IpTypeFieldConditionalModel {
  final String dependsOn;
  final String operator;
  final dynamic value;

  IpTypeFieldConditionalModel({
    required this.dependsOn,
    required this.operator,
    required this.value,
  });

  factory IpTypeFieldConditionalModel.fromJson(Map<String, dynamic> json) {
    return IpTypeFieldConditionalModel(
      dependsOn: json['dependsOn'] ?? '',
      operator: json['operator'] ?? 'equals',
      value: json['value'],
    );
  }

  factory IpTypeFieldConditionalModel.fromEntity(
    IpTypeFieldConditionalEntity entity,
  ) {
    return IpTypeFieldConditionalModel(
      dependsOn: entity.dependsOn,
      operator: entity.operator,
      value: entity.value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dependsOn': dependsOn,
      'operator': operator,
      'value': value,
    };
  }

  IpTypeFieldConditionalEntity toEntity() {
    return IpTypeFieldConditionalEntity(
      dependsOn: dependsOn,
      operator: operator,
      value: value,
    );
  }
}