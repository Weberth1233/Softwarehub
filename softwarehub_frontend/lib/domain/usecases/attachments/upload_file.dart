import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../repositories/iattachment_repository.dart';

class UploadFile {
  final IAttachmentRepository repository;

  UploadFile( this.repository);

  Future<Either<Failure,String>> call({required int id, String? filePath, Uint8List? fileBytes, required String fileName}) {
    return repository.uploadDocument(id: id, fileName: fileName, fileBytes: fileBytes, filePath: filePath);
  }
}