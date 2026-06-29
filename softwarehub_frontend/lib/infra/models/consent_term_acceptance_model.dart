import '../../domain/entities/consent_term_acceptance_entity.dart';

class ConsentTermAcceptanceModel {
  final int consentTermId;

  ConsentTermAcceptanceModel({required this.consentTermId});

  factory ConsentTermAcceptanceModel.fromJson(Map<String, dynamic> json) {
    return ConsentTermAcceptanceModel(
      consentTermId: json['consentTermId']
    );
  }

  factory ConsentTermAcceptanceModel.fromEntity(ConsentTermAcceptanceEntity entity) {
    return ConsentTermAcceptanceModel(
      consentTermId: entity.consentTermId
    );
  }

  ConsentTermAcceptanceEntity toEntity() {
    return ConsentTermAcceptanceEntity(
      consentTermId: consentTermId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'consentTermId': consentTermId,
    };
  }
}