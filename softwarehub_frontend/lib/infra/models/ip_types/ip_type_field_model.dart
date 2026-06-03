import '../../../domain/entities/ip_type_entity.dart';
import 'ip_type_field_conditional_model.dart';
import 'ip_type_field_option_model.dart';
import 'ip_type_field_validation_model.dart';

class IpTypeFieldModel {
  final String key;
  final String name;
  final String type;
  final bool requiredField;
  final String? placeholder;
  final int? order;
  final IpTypeFieldValidationModel? validation;
  final List<IpTypeFieldOptionModel> options;
  final IpTypeFieldConditionalModel? conditional;

  IpTypeFieldModel({
    required this.key,
    required this.name,
    required this.type,
    required this.requiredField,
    this.placeholder,
    this.order,
    this.validation,
    this.options = const [],
    this.conditional,
  });

  factory IpTypeFieldModel.fromJson(Map<String, dynamic> json) {
    return IpTypeFieldModel(
      key: json['key'] ?? json['name'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? 'text',
      requiredField: json['required'] ?? false,
      placeholder: json['placeholder'],
      order: json['order'],
      validation: json['validation'] != null
          ? IpTypeFieldValidationModel.fromJson(json['validation'])
          : null,
      options: (json['options'] as List<dynamic>? ?? [])
          .map(
            (option) => IpTypeFieldOptionModel.fromJson(
              option as Map<String, dynamic>,
            ),
          )
          .toList(),
      conditional: json['conditional'] != null
          ? IpTypeFieldConditionalModel.fromJson(json['conditional'])
          : null,
    );
  }

  factory IpTypeFieldModel.fromEntity(IpTypeFieldEntity entity) {
    return IpTypeFieldModel(
      key: entity.key,
      name: entity.name,
      type: entity.type,
      requiredField: entity.requiredField,
      placeholder: entity.placeholder,
      order: entity.order,
      validation: entity.validation != null
          ? IpTypeFieldValidationModel.fromEntity(entity.validation!)
          : null,
      options: entity.options
          .map(IpTypeFieldOptionModel.fromEntity)
          .toList(),
      conditional: entity.conditional != null
          ? IpTypeFieldConditionalModel.fromEntity(entity.conditional!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'type': type,
      'required': requiredField,
      'placeholder': placeholder,
      'order': order,
      'validation': validation?.toJson(),
      'options': options.map((option) => option.toJson()).toList(),
      'conditional': conditional?.toJson(),
    };
  }

  IpTypeFieldEntity toEntity() {
    return IpTypeFieldEntity(
      key: key,
      name: name,
      type: type,
      requiredField: requiredField,
      placeholder: placeholder,
      order: order,
      validation: validation?.toEntity(),
      options: options.map((option) => option.toEntity()).toList(),
      conditional: conditional?.toEntity(),
    );
  }
}