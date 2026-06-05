class ProcessRoyaltyDistributionRequestEntity {
  final int processId;
  final int? changeRequestId;
  final List<RoyaltyShareEntity> shares;

  ProcessRoyaltyDistributionRequestEntity({
    required this.processId,
    this.changeRequestId,
    required this.shares,
  });
}

class RoyaltyShareEntity {
  final String type;
  final int? userId;
  final int? educationalInstitutionId;
  final double percentage;

  RoyaltyShareEntity({
    required this.type,
    this.userId,
    this.educationalInstitutionId,
    required this.percentage,
  });
}