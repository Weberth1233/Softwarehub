import '../../../domain/entities/ip_type_entity.dart';

class IpTypeFieldValidationModel {
  final int? minLength;
  final int? maxLength;
  final int? min;
  final int? max;
  final String? regex;
  final String? message;

  IpTypeFieldValidationModel({
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
    this.regex,
    this.message,
  });

  factory IpTypeFieldValidationModel.fromJson(Map<String, dynamic> json) {
    return IpTypeFieldValidationModel(
      minLength: json['minLength'],
      maxLength: json['maxLength'],
      min: json['min'],
      max: json['max'],
      regex: json['regex'],
      message: json['message'],
    );
  }

  factory IpTypeFieldValidationModel.fromEntity(
    IpTypeFieldValidationEntity entity,
  ) {
    return IpTypeFieldValidationModel(
      minLength: entity.minLength,
      maxLength: entity.maxLength,
      min: entity.min,
      max: entity.max,
      regex: entity.regex,
      message: entity.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minLength': minLength,
      'maxLength': maxLength,
      'min': min,
      'max': max,
      'regex': regex,
      'message': message,
    };
  }

  IpTypeFieldValidationEntity toEntity() {
    return IpTypeFieldValidationEntity(
      minLength: minLength,
      maxLength: maxLength,
      min: min,
      max: max,
      regex: regex,
      message: message,
    );
  }
}