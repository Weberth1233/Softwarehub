import '../../../domain/entities/user/user_entity.dart';
import 'address_model.dart';
import 'user_educational_institution_link_model.dart';

class UserModel {
  final int? id;
  final String email;
  final String cpf;
  final String password;
  final String phoneNumber;
  final String birthDate;
  final String profession;
  final String fullName;
  final bool isEnabled;
  final List<UserEducationalInstitutionLinkModel>
  userEducationalInstitutionLinks;
  final AddressModel address;

  UserModel({
    this.id,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birthDate: json['birthDate'] ?? '',
      profession: json['profession'] ?? '',
      fullName: json['fullName'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      userEducationalInstitutionLinks:
          (json['userEducationalInstitutionLinks'] as List<dynamic>? ?? [])
              .map(
                (item) => UserEducationalInstitutionLinkModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      address: AddressModel.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "cpf": cpf,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate,
      "profession": profession,
      "fullName": fullName,
      "isEnabled": isEnabled,
      "userEducationalInstitutionLinks": userEducationalInstitutionLinks
          .map(
            (link) => UserEducationalInstitutionLinkModel.fromEntity(
              link.toEntity(),
            ).toRequestJson(),
          )
          .toList(),
      "address": address.toJson(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      cpf: entity.cpf,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      birthDate: entity.birthDate,
      profession: entity.profession,
      fullName: entity.fullName,
      isEnabled: entity.isEnabled,
      userEducationalInstitutionLinks: entity.userEducationalInstitutionLinks
          .map(UserEducationalInstitutionLinkModel.fromEntity)
          .toList(),
      address: AddressModel.fromEntity(entity.address),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      cpf: cpf,
      password: password,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
      profession: profession,
      fullName: fullName,
      isEnabled: isEnabled,
      userEducationalInstitutionLinks: userEducationalInstitutionLinks
          .map((item) => item.toEntity())
          .toList(),
      address: address.toEntity(),
    );
  }
}
