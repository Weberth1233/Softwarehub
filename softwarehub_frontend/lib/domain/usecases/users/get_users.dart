import '../../entities/user/user_entity.dart';
import '../../repositories/iuser_repository.dart';
import '../generic/generic_usecases.dart';

class GetUsers extends GetPaginatedList<UserEntity, IUserRepository> {
  GetUsers({required super.repository});
}
