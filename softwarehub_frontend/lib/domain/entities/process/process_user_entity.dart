import 'package:nit_sgpi_frontend/domain/entities/user/user_educational_institution_link_entity.dart';

class ProcessUserEntity {
  final int id;
  final String userName;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String profession;
  final String fullName;
 final List<UserEducationalInstitutionLinkEntity> userEducationalInstitutionLinks;
 
  ProcessUserEntity({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.profession,
    required this.fullName,
    required this.userEducationalInstitutionLinks,
  });
}
