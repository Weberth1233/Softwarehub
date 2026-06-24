import '../../entities/user/user_entity.dart';
import '../../repositories/iuser_repository.dart';
import '../generic/generic_usecases.dart';

class PutUser extends
        PutUsecase<UserEntity, String, IUserRepository> {
  PutUser({required super.repository});
  
}