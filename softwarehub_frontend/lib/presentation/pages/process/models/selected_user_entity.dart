

import '../../../../domain/entities/process/process_user_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';

class SelectedUserEntity {
  final int id;
  final String fullName;
  final String email;

  const SelectedUserEntity({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory SelectedUserEntity.fromUserEntity(UserEntity user) {
    return SelectedUserEntity(
      id: user.id!,
      fullName: user.fullName,
      email: user.email,
    );
  }

  factory SelectedUserEntity.fromProcessUserEntity(ProcessUserEntity author) {
    return SelectedUserEntity(
      id: author.id!,
      fullName: author.fullName,
      email: author.email,
    );
  }
}