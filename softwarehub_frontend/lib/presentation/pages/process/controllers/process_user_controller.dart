import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/users/get_users.dart';
import '../../../../domain/entities/process/process_user_entity.dart';
import '../models/selected_user_entity.dart';

class ProcessUserController extends GetxController {
  final GetUsers getUsers;
  ProcessUserController(this.getUsers);

  final RxMap<int, SelectedUserEntity> selectedUsers =
      <int, SelectedUserEntity>{}.obs;

  final RxBool isLoading = false.obs;
  final RxList<UserEntity> users = <UserEntity>[].obs;
  final RxString errorMessage = ''.obs;

  final RxString searchFilter = ''.obs;

  final RxInt page = 0.obs;
  final int size = 6;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void toggleUser(UserEntity user) {
    final id = user.id;
    if (id == null) return;

    if (selectedUsers.containsKey(id)) {
      selectedUsers.remove(id);
    } else {
      selectedUsers[id] = SelectedUserEntity.fromUserEntity(user);
    }
  }

  void removeUserById(int id) {
    selectedUsers.remove(id);
  }

  void searchByFilter(String query) {
    searchFilter.value = query;
    fetchUsers(loadMore: false);
  }

  Future<void> fetchUsers({bool loadMore = false}) async {
    if (isLoading.value || (loadMore && !hasMore.value)) return;

    isLoading.value = true;
    errorMessage.value = '';

    if (loadMore) {
      page.value++;
    } else {
      page.value = 0;
      users.clear();
      hasMore.value = true;
    }
    final values = <String, String>{
      'page': page.toString(),
      'page-size': size.toString(),
    };

    if (searchFilter.value.trim().isNotEmpty) {
      values['search'] = searchFilter.value.trim();
    }
    final result = await getUsers(values);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        if (loadMore && page.value > 0) page.value--;
      },
      (pagedResult) {
        users.assignAll(pagedResult.content);
        hasMore.value = pagedResult.content.length >= size;
      },
    );

    isLoading.value = false;
  }

  Future<void> fetchPreviousPage() async {
    if (isLoading.value || page.value == 0) return;

    isLoading.value = true;
    errorMessage.value = '';

    page.value--;

    final values = <String, String>{
      'page': page.toString(),
      'page-size': size.toString(),
    };

    if (searchFilter.value.trim().isNotEmpty) {
      values['search'] = searchFilter.value.trim();
    }
    final result = await getUsers(values);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        page.value++;
      },
      (pagedResult) {
        users.assignAll(pagedResult.content);
        hasMore.value = true;
      },
    );

    isLoading.value = false;
  }

  void setInitialSelectedProcessAuthors(List<ProcessUserEntity> authors) {
    selectedUsers.clear();

    for (final author in authors) {
      final id = author.id;

      selectedUsers[id] = SelectedUserEntity.fromProcessUserEntity(author);
    }
  }

  void clearSelectedUsers() {
    selectedUsers.clear();
  }
}
