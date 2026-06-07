import 'package:dartz/dartz.dart';

import '../../../domain/core/errors/exceptions.dart';
import '../../../domain/core/errors/failures.dart';

abstract class BaseRepository {
  Future<Either<Failure, T>> handleRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Erro inesperado!"));
    }
  }
}
