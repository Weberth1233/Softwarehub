import 'package:dartz/dartz.dart';

import '../core/errors/failures.dart';

abstract class IGenericRepository<T> {
  Future<Either<Failure, List<T>>> getList();
}