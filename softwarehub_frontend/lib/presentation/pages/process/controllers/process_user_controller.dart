import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/users/get_users.dart';

class ProcessUserController extends GetxController {
  final GetUsers getUsers;
  ProcessUserController(this.getUsers);

  final RxMap<int, UserEntity> selectedUsers = <int, UserEntity>{}.obs;

  final RxBool isLoading = false.obs;
  final RxList<UserEntity> users = <UserEntity>[].obs;
  final RxString errorMessage = ''.obs;

  final RxString searchFilter = ''.obs;

  // final RxString fullNameFilter = ''.obs;
  // final RxString emailFilter = ''.obs;
  // final RxString cpfFilter = ''.obs;

  final RxInt page = 0.obs;
  final int size = 6;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void toggleUser(UserEntity user) {
    if (user.id == null) return;

    if (selectedUsers.containsKey(user.id)) {
      selectedUsers.remove(user.id);
    } else {
      selectedUsers[user.id!] = user;
    }
  }

  void removeUserById(int id) {
    selectedUsers.remove(id);
  }

  void searchByFilter(String query) {
    searchFilter.value = query;
    fetchUsers(loadMore: false);
  }

  // void searchByEmail(String query) {
  //   emailFilter.value = query;
  //   fetchUsers(loadMore: false);
  // }

  // void searchByCPF(String query) {
  //   cpfFilter.value = query;
  //   fetchUsers(loadMore: false);
  // }

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

    final result = await getUsers(
      search: searchFilter.value,
      page: page.value,
      size: size,
    );

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

    final result = await getUsers(
      search: searchFilter.value,
      page: page.value,
      size: size,
    );

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

}