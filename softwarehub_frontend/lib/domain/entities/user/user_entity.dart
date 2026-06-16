import 'address_entity.dart';
import 'user_educational_institution_link_entity.dart';

class UserEntity {
  final int? id;
  final String userName;
  final String email;
  final String cpf;
  final String password;
  final String phoneNumber;
  final String birthDate;
  final String profession;
  final String fullName;

  final bool isEnabled;
  final List<UserEducationalInstitutionLinkEntity> userEducationalInstitutionLinks;
  final AddressEntity address;

  UserEntity({
    this.id,
    required this.userName,
    required this.email,
    required this.cpf,
    required this.password,
    required this.phoneNumber,
    required this.birthDate,
    required this.profession,
    required this.fullName,
    required this.isEnabled,
    required this.userEducationalInstitutionLinks,
    required this.address,
  });
}