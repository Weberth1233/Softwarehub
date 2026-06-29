import '../../entities/user/user_entity.dart';
import '../../repositories/iregister_repository.dart';
import '../generic/generic_usecases.dart';

class PostUser extends PostUsecase<UserEntity, String, IRegisterRepository> {
  PostUser({required super.repository});
}