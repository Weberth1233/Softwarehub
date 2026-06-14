class ApplicationFieldEntity {
  final int id;
  final String code;
  final String name;
  final String description;
  final int applicationAreaId;
  final String applicationAreaCode;
  final String applicationAreaName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ApplicationFieldEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.applicationAreaId,
    required this.applicationAreaCode,
    required this.applicationAreaName,
    required this.createdAt,
    required this.updatedAt,
  });
}