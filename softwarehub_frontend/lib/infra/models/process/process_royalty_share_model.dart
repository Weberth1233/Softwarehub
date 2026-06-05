
import '../../../domain/entities/process/process_royalty_share_entity.dart';

class ProcessRoyaltyShareModel {
  final int id;
  final String type;
  final int? userId;
  final String? userName;
  final int? educationalInstitutionId;
  final String? educationalInstitutionName;
  final double percentage;

  ProcessRoyaltyShareModel({
    required this.id,
    required this.type,
    required this.userId,
    required this.userName,
    required this.educationalInstitutionId,
    required this.educationalInstitutionName,
    required this.percentage,
  });

  factory ProcessRoyaltyShareModel.fromJson(Map<String, dynamic> json) {
    return ProcessRoyaltyShareModel(
      id: json['id'],
      type: json['type'],
      userId: json['userId'],
      userName: json['userName'],
      educationalInstitutionId: json['educationalInstitutionId'],
      educationalInstitutionName: json['educationalInstitutionName'],
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'userId': userId,
      'userName': userName,
      'educationalInstitutionId': educationalInstitutionId,
      'educationalInstitutionName': educationalInstitutionName,
      'percentage': percentage,
    };
  }

  ProcessRoyaltyShareEntity toEntity() {
    return ProcessRoyaltyShareEntity(
      id: id,
      type: type,
      userId: userId,
      userName: userName,
      educationalInstitutionId: educationalInstitutionId,
      educationalInstitutionName: educationalInstitutionName,
      percentage: percentage,
    );
  }

  factory ProcessRoyaltyShareModel.fromEntity(
    ProcessRoyaltyShareEntity entity,
  ) {
    return ProcessRoyaltyShareModel(
      id: entity.id,
      type: entity.type,
      userId: entity.userId,
      userName: entity.userName,
      educationalInstitutionId: entity.educationalInstitutionId,
      educationalInstitutionName: entity.educationalInstitutionName,
      percentage: entity.percentage,
    );
  }
}