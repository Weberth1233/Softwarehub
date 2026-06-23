import 'package:dartz/dartz.dart';
import '../../domain/core/errors/failures.dart';
import '../../domain/entities/consent_term_entity.dart';
import '../../domain/repositories/iconsent_term_repository.dart';
import '../core/repositories/base_repository.dart';
import '../datasources/consent_term_remote_datasource.dart';

class ConsentTermRepositoryImpl extends BaseRepository
    implements IConsentTermRepository {
  final IConsentTermRemoteDataSource remoteDataSource;

  ConsentTermRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ConsentTermEntity>> getById(int id) async {
    return handleRequest(() {
      return remoteDataSource.getById(id);
    });
  }
}
