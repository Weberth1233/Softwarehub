import '../../../domain/entities/ip_type_entity.dart';
import 'ip_type_field_model.dart';

class IpTypeStructureModel {
  final List<IpTypeFieldModel> fields;

  IpTypeStructureModel({
    required this.fields,
  });

  factory IpTypeStructureModel.fromJson(Map<String, dynamic> json) {
    return IpTypeStructureModel(
      fields: (json['fields'] as List<dynamic>? ?? [])
          .map(
            (field) => IpTypeFieldModel.fromJson(
              field as Map<String, dynamic>,
            ),
          )
          .toList()
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0)),
    );
  }

  factory IpTypeStructureModel.fromEntity(IpTypeStructureEntity entity) {
    return IpTypeStructureModel(
      fields: entity.fields
          .map(IpTypeFieldModel.fromEntity)
          .toList()
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }

  IpTypeStructureEntity toEntity() {
    return IpTypeStructureEntity(
      fields: fields.map((field) => field.toEntity()).toList(),
    );
  }
}