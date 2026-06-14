class FirstStageProcess {
  final int? idProcess;
  final String title;
  final List<int> idsUser;
  final List<int> idsExternalAuthors;
  final bool isEdit;
  final String? originalIpTypeId;
  final Map<String, dynamic>? originalFormData;

  FirstStageProcess({
    this.idProcess,
    required this.title,
    required this.idsUser,
    required this.idsExternalAuthors,
    this.isEdit = false,
    this.originalIpTypeId,
    this.originalFormData,
  });
}