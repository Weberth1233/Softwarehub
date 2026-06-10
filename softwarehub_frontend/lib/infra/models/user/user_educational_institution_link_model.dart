import '../educational_institution_model.dart';
import '../types_link_model.dart';
import '../../../domain/entities/user/user_educational_institution_link_entity.dart';

class UserEducationalInstitutionLinkModel {
  final int? id;
  final EducationalInstitutionModel educationalInstitution;
  final TypesLinkModel typesLink;
  final String? createdAt;
  final String? updatedAt;

  UserEducationalInstitutionLinkModel({
    this.id,
    required this.educationalInstitution,
    required this.typesLink,
    this.createdAt,
    this.updatedAt,
  });

  factory UserEducationalInstitutionLinkModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserEducationalInstitutionLinkModel(
      id: json['id'],
      educationalInstitution: EducationalInstitutionModel.fromJson(
        json['educationalInstitution'],
      ),
      typesLink: TypesLinkModel.fromJson(
        json['typesLink'],
      ),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "educationalInstitution": educationalInstitution.toJson(),
      "typesLink": typesLink.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  Map<String, dynamic> toRequestJson() {
    return {
      "educationalInstitutionId": educationalInstitution.id,
      "typesLinkId": typesLink.id,
    };
  }

  factory UserEducationalInstitutionLinkModel.fromEntity(
    UserEducationalInstitutionLinkEntity entity,
  ) {
    return UserEducationalInstitutionLinkModel(
      id: entity.id,
      educationalInstitution: EducationalInstitutionModel.fromEntity(
        entity.educationalInstitution,
      ),
      typesLink: TypesLinkModel.fromEntity(entity.typesLink),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserEducationalInstitutionLinkEntity toEntity() {
    return UserEducationalInstitutionLinkEntity(
      id: id,
      educationalInstitution: educationalInstitution.toEntity(),
      typesLink: typesLink.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}