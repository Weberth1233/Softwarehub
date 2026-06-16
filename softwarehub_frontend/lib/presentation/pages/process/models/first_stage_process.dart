import '../../../../domain/entities/process/process_royalty_distribution_response_entity.dart' show ProcessRoyaltyDistributionResponseEntity;

class FirstStageProcess {
  final int? idProcess;
  final String title;
  final List<int> idsUser;
  final List<int> idsExternalAuthors;
  final bool isEdit;
  final String? originalIpTypeId;
  final Map<String, dynamic>? originalFormData;
    final ProcessRoyaltyDistributionResponseEntity? activeRoyaltyDistribution;


  FirstStageProcess({
    this.idProcess,
    required this.title,
    required this.idsUser,
    required this.idsExternalAuthors,
    this.isEdit = false,
    this.originalIpTypeId,
    this.originalFormData,
    this.activeRoyaltyDistribution
  });
}