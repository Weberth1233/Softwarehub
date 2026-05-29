import 'educational_institution_entity.dart';
import 'types_link_entity.dart';

class UserEducationalInstitutionLinkEntity {
  final int? id;
  final EducationalInstitutionEntity educationalInstitution;
  final TypesLinkEntity typesLink;
  final String? createdAt;
  final String? updatedAt;

  UserEducationalInstitutionLinkEntity({
    this.id,
    required this.educationalInstitution,
    required this.typesLink,
    this.createdAt,
    this.updatedAt,
  });
}