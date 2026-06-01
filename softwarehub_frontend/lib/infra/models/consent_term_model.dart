import '../../domain/entities/consent_term_entity.dart';

class ConsentTermModel {
  final int id;
  final String content;
  final DateTime createdAt;
  final int version;

  ConsentTermModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.version,
  });

  factory ConsentTermModel.fromJson(Map<String, dynamic> json) {
    return ConsentTermModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      version: json['version'] ?? 0,
    );
  }

  factory ConsentTermModel.fromEntity(ConsentTermEntity entity) {
    return ConsentTermModel(
      id: entity.id,
      content: entity.content,
      createdAt: entity.createdAt,
      version: entity.version,
    );
  }

  ConsentTermEntity toEntity() {
    return ConsentTermEntity(
      id: id,
      content: content,
      createdAt: createdAt,
      version: version,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'version': version,
    };
  }
}