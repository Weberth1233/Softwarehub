import 'process_royalty_share_entity.dart';

class ProcessRoyaltyDistributionResponseEntity {
  final int id;
  final int processId;
  final int version;
  final String status;
  final int? changeRequestId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProcessRoyaltyShareEntity> shares;

  ProcessRoyaltyDistributionResponseEntity({
    required this.id,
    required this.processId,
    required this.version,
    required this.status,
    required this.changeRequestId,
    required this.createdAt,
    required this.updatedAt,
    required this.shares,
  });
}