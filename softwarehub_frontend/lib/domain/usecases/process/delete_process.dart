import 'package:dartz/dartz.dart';
import 'package:nit_sgpi_frontend/domain/usecases/generic/generic_usecases.dart';
import '../../core/errors/failures.dart';
import '../../repositories/iprocess_repository.dart';

class DeleteProcess extends DeleteUsecase<String, IProcessRepository> {
  DeleteProcess({required super.repository});
  // final IProcessRepository repository;

  // DeleteProcess({required this.repository});

  // Future<Either<Failure, String>> call(int idProcess) async{
  //   final result = await repository.deleteProcessById(idProcess);
  //   return result;
  // }
}