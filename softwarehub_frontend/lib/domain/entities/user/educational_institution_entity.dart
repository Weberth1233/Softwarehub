class EducationalInstitutionEntity {
  final int? id;
  final String name;
  final String cnpj;
  final bool active;
  final String institutionType;
  final String? createdAt;
  final String? updatedAt;

  EducationalInstitutionEntity({
    this.id,
    required this.name,
    required this.cnpj,
    required this.active,
    required this.institutionType,
    this.createdAt,
    this.updatedAt,
  });
}