import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../repositories/iprocess_repository.dart';

class DeleteProcess {
  final IProcessRepository repository;

  DeleteProcess({required this.repository});

  Future<Either<Failure, String>> call(int idProcess) async{
    final result = await repository.deleteProcessById(idProcess);
    return result;
  }
}