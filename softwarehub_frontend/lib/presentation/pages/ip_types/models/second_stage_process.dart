import '../../../../domain/entities/ip_type_entity.dart';
import '../../process/models/first_stage_process.dart';

class SecondStageProcess {
  final FirstStageProcess firstStageProcess;
  final IpTypeEntity item;
  final bool isEdit;
  final String? originalIpTypeId;
  final Map<String, dynamic>? originalFormData;

  SecondStageProcess({
    required this.firstStageProcess,
    required this.item,
    this.isEdit = false,
    this.originalIpTypeId,
    this.originalFormData,
  });
}