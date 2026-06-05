import '../../../domain/entities/process/process_royalty_distribution_request_entity.dart';

class ProcessRoyaltyDistributionRequestModel {
  final int processId;
  final int? changeRequestId;
  final List<RoyaltyShareModel> shares;

  const ProcessRoyaltyDistributionRequestModel({
    required this.processId,
    this.changeRequestId,
    required this.shares,
  });

  factory ProcessRoyaltyDistributionRequestModel.fromJson(Map<String, dynamic> json) {
    return ProcessRoyaltyDistributionRequestModel(
      processId: json['processId'],
      changeRequestId: json['changeRequestId'],
      shares: (json['shares'] as List<dynamic>)
          .map((shareJson) => RoyaltyShareModel.fromJson(shareJson))
          .toList(),
    );
  }

  factory ProcessRoyaltyDistributionRequestModel.fromEntity(
    ProcessRoyaltyDistributionRequestEntity entity,
  ) {
    return ProcessRoyaltyDistributionRequestModel(
      processId: entity.processId,
      changeRequestId: entity.changeRequestId,
      shares: entity.shares
          .map((shareEntity) => RoyaltyShareModel.fromEntity(shareEntity))
          .toList(),
    );
  }

  ProcessRoyaltyDistributionRequestEntity toEntity() {
    return ProcessRoyaltyDistributionRequestEntity(
      processId: processId,
      changeRequestId: changeRequestId,
      shares: shares.map((shareModel) => shareModel.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'processId': processId,
      'changeRequestId': changeRequestId,
      'shares': shares.map((share) => share.toJson()).toList(),
    };
  }
}

class RoyaltyShareModel {
  final String type;
  final int? userId;
  final int? educationalInstitutionId;
  final double percentage;

  const RoyaltyShareModel({
    required this.type,
    this.userId,
    this.educationalInstitutionId,
    required this.percentage,
  });

  factory RoyaltyShareModel.fromJson(Map<String, dynamic> json) {
    return RoyaltyShareModel(
      type: json['type'],
      userId: json['userId'],
      educationalInstitutionId: json['educationalInstitutionId'],
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  factory RoyaltyShareModel.fromEntity(RoyaltyShareEntity entity) {
    return RoyaltyShareModel(
      type: entity.type,
      userId: entity.userId,
      educationalInstitutionId: entity.educationalInstitutionId,
      percentage: entity.percentage,
    );
  }

  RoyaltyShareEntity toEntity() {
    return RoyaltyShareEntity(
      type: type,
      userId: userId,
      educationalInstitutionId: educationalInstitutionId,
      percentage: percentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'userId': userId,
      'educationalInstitutionId': educationalInstitutionId,
      'percentage': percentage,
    };
  }
}