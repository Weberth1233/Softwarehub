class ProcessRoyaltyShareEntity {
  final int id;
  final String type;
  final int? userId;
  final String? userName;
  final int? educationalInstitutionId;
  final String? educationalInstitutionName;
  final double percentage;

  ProcessRoyaltyShareEntity({
    required this.id,
    required this.type,
    required this.userId,
    required this.userName,
    required this.educationalInstitutionId,
    required this.educationalInstitutionName,
    required this.percentage,
  });
}