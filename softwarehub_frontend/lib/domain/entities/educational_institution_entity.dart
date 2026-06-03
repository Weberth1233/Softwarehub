class EducationalInstitutionEntity {
  final int id;
  final String name;
  final String cnpj;
  final bool active;
  final String institutionType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EducationalInstitutionEntity({
    required this.id,
    required this.name,
    required this.cnpj,
    required this.active,
    required this.institutionType,
    required this.createdAt,
    required this.updatedAt,
  });
}