import 'package:nit_sgpi_frontend/infra/models/user/user_educational_institution_link_model.dart';

import '../../../domain/entities/process/process_user_entity.dart';

class ProcessUserModel {
  final int id;
  final String userName;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String profession;
  final String fullName;
  final List<UserEducationalInstitutionLinkModel>
  userEducationalInstitutionLinks;

  ProcessUserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.profession,
    required this.fullName,
    required this.userEducationalInstitutionLinks,
  });

  factory ProcessUserModel.fromJson(Map<String, dynamic> json) {
    return ProcessUserModel(
      id: json['id'],
      userName: json['userName'] ?? '',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      birthDate: json['birthDate'],
      profession: json['profession'],
      fullName: json['fullName'], 
      userEducationalInstitutionLinks:
          (json['userEducationalInstitutionLinks'] as List<dynamic>? ?? [])
              .map(
                (item) => UserEducationalInstitutionLinkModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      
    );
  }

  factory ProcessUserModel.fromEntity(ProcessUserEntity entity) {
    return ProcessUserModel(
      id: entity.id,
      birthDate: entity.birthDate,
      phoneNumber: entity.phoneNumber,
      profession: entity.profession,
      userName: entity.userName,
      fullName: entity.fullName,
      email: entity.email,
      userEducationalInstitutionLinks: entity.userEducationalInstitutionLinks
          .map(UserEducationalInstitutionLinkModel.fromEntity)
          .toList(),
    );
  }

  ProcessUserEntity toEntity() {
    return ProcessUserEntity(
      id: id,
      userName: userName,
      birthDate: birthDate,
      phoneNumber: phoneNumber,
      profession: profession,
      email: email,
      fullName: fullName,
      userEducationalInstitutionLinks: userEducationalInstitutionLinks
          .map((item) => item.toEntity())
          .toList(),
    );
  }
}
