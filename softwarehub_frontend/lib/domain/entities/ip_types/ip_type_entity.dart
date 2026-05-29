class IpTypeEntity {
  final int id;
  final String name;
  final String color;
  final IpTypeStructureEntity formStructure;

  IpTypeEntity({
    required this.id,
    required this.name,
    required this.color,
    required this.formStructure,
  });
}

class IpTypeStructureEntity {
  final List<IpTypeFieldEntity> fields;

  IpTypeStructureEntity({
    required this.fields,
  });
}

class IpTypeFieldEntity {
  final String key;
  final String name;
  final String type;
  final bool requiredField;
  final String? placeholder;
  final int? order;
  final IpTypeFieldValidationEntity? validation;
  final List<IpTypeFieldOptionEntity> options;
  final IpTypeFieldConditionalEntity? conditional;

  IpTypeFieldEntity({
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
}

class IpTypeFieldValidationEntity {
  final int? minLength;
  final int? maxLength;
  final int? min;
  final int? max;
  final String? regex;
  final String? message;

  IpTypeFieldValidationEntity({
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
    this.regex,
    this.message,
  });
}

class IpTypeFieldOptionEntity {
  final String label;
  final String value;

  IpTypeFieldOptionEntity({
    required this.label,
    required this.value,
  });
}

class IpTypeFieldConditionalEntity {
  final String dependsOn;
  final String operator;
  final dynamic value;

  IpTypeFieldConditionalEntity({
    required this.dependsOn,
    required this.operator,
    required this.value,
  });
}