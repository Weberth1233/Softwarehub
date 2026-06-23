import '../../../../domain/entities/paged_result_entity.dart';

class PagedResultModel<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final bool last;
  final bool first;
  final int size;
  final int number;
  final int numberOfElements;
  final bool empty;

  PagedResultModel({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.last,
    required this.first,
    required this.size,
    required this.number,
    required this.numberOfElements,
    required this.empty,
  });

  factory PagedResultModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PagedResultModel<T>(
      content: (json['content'] as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['totalPages'] as int,
      totalElements: json['totalElements'] as int,
      last: json['last'] as bool,
      first: json['first'] as bool,
      size: json['size'] as int,
      number: json['number'] as int,
      numberOfElements: json['numberOfElements'] as int,
      empty: json['empty'] as bool,
    );
  }

  PagedResultEntity<R> toEntity<R>(
    R Function(T model) toEntityT,
  ) {
    return PagedResultEntity<R>(
      content: content.map((e) => toEntityT(e)).toList(),
      totalPages: totalPages,
      totalElements: totalElements,
      last: last,
      first: first,
      size: size,
      number: number,
      numberOfElements: numberOfElements,
      empty: empty,
    );
  }
}