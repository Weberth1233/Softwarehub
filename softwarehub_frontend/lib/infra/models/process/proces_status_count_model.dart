// data/models/process_status_count_model.dart

import '../../../domain/entities/process/process_status_count_entity.dart';
class ProcessStatusCountModel extends ProcessStatusCountEntity {
  
  ProcessStatusCountModel({
    required super.status,
    required super.amount,
    required super.statusLabel 
  });

  factory ProcessStatusCountModel.fromJson(Map<String, dynamic> json) {
    return ProcessStatusCountModel(
      status: json['status'] as String,
      amount: json['amount'] as int,
      statusLabel: json['statusLabel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'amount': amount,
      'statusLabel': statusLabel
    };
  }
}
