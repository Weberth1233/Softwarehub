import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../entities/justification/justification_request_entity.dart';
import '../../repositories/ijustification_repository.dart';

// class PutJustification {
//   final IJustificationRepository repository;

//   PutJustification({required this.repository});
  
//   Future<Either<Failure, String>> call(int idJustification,JustificationRequestEntity justification) async{
//     final result = await repository.putJustification(idJustification, justification);
//     return result;
//   }
// }