import '../../../domain/entities/user/user_entity.dart';
import 'address_model.dart';
import 'user_educational_institution_link_model.dart';

class UserModel {
  final int? id;
  final String userName;
  final String email;
  final String cpf;
  final String password;
  final String phoneNumber;
  final String birthDate;
  final String profession;
  final String fullName;
  final String role;
  final bool isEnabled;
  final List<UserEducationalInstitutionLinkModel>
  userEducationalInstitutionLinks;
  final AddressModel address;

  UserModel({
    this.id,
    required this.userName,
    required this.email,
    required this.cpf,
    required this.password,
    required this.phoneNumber,
    required this.birthDate,
    required this.profession,
    required this.fullName,
    required this.role,
    required this.isEnabled,
    required this.userEducationalInstitutionLinks,
    required this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      birthDate: json['birthDate'] ?? '',
      profession: json['profession'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
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
      "userName": userName,
      "email": email,
      "password": password,
      "cpf": cpf,
      "phoneNumber": phoneNumber,
      "birthDate": birthDate,
      "profession": profession,
      "fullName": fullName,
      "role": role,
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
      userName: entity.userName,
      email: entity.email,
      cpf: entity.cpf,
      password: entity.password,
      phoneNumber: entity.phoneNumber,
      birthDate: entity.birthDate,
      profession: entity.profession,
      fullName: entity.fullName,
      role: entity.role,
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
      userName: userName,
      email: email,
      cpf: cpf,
      password: password,
      phoneNumber: phoneNumber,
      birthDate: birthDate,
      profession: profession,
      fullName: fullName,
      role: role,
      isEnabled: isEnabled,
      userEducationalInstitutionLinks: userEducationalInstitutionLinks
          .map((item) => item.toEntity())
          .toList(),
      address: address.toEntity(),
    );
  }
}
