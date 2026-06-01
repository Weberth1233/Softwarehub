class ConsentTermEntity {
  final int id;
  final String content;
  final DateTime createdAt;
  final int version;

  ConsentTermEntity({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.version,
  });
}