import '../../../domain/entities/process/process_royalty_distribution_response_entity.dart';
import 'process_royalty_share_model.dart';

class ProcessRoyaltyDistributionResponseModel {
  final int id;
  final int processId;
  final int version;
  final String status;
  final int? changeRequestId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProcessRoyaltyShareModel> shares;

  ProcessRoyaltyDistributionResponseModel({
    required this.id,
    required this.processId,
    required this.version,
    required this.status,
    required this.changeRequestId,
    required this.createdAt,
    required this.updatedAt,
    required this.shares,
  });

  factory ProcessRoyaltyDistributionResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProcessRoyaltyDistributionResponseModel(
      id: json['id'],
      processId: json['processId'],
      version: json['version'],
      status: json['status'],
      changeRequestId: json['changeRequestId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      shares: (json['shares'] as List? ?? [])
          .map(
            (e) => ProcessRoyaltyShareModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'processId': processId,
      'version': version,
      'status': status,
      'changeRequestId': changeRequestId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'shares': shares.map((e) => e.toJson()).toList(),
    };
  }

  ProcessRoyaltyDistributionResponseEntity toEntity() {
    return ProcessRoyaltyDistributionResponseEntity(
      id: id,
      processId: processId,
      version: version,
      status: status,
      changeRequestId: changeRequestId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      shares: shares.map((e) => e.toEntity()).toList(),
    );
  }

  factory ProcessRoyaltyDistributionResponseModel.fromEntity(
    ProcessRoyaltyDistributionResponseEntity entity,
  ) {
    return ProcessRoyaltyDistributionResponseModel(
      id: entity.id,
      processId: entity.processId,
      version: entity.version,
      status: entity.status,
      changeRequestId: entity.changeRequestId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      shares: entity.shares
          .map((e) => ProcessRoyaltyShareModel.fromEntity(e))
          .toList(),
    );
  }
}