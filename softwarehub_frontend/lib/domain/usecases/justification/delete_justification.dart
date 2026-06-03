import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../repositories/ijustification_repository.dart';

class DeleteJustification {
  final IJustificationRepository repository;

  DeleteJustification({required this.repository});

  Future<Either<Failure, String>> call(int idJustification) async{
    final result = await repository.deleteJustification(idJustification);
    return result;
  }
}