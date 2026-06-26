import 'package:get/get.dart';

import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../domain/entities/process/process_user_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../../domain/usecases/users/get_users.dart';
import '../../../shared/utils/app_toast.dart';
import '../models/selected_user_entity.dart';

class ProcessController extends GetxController {
  final GetUsers _getUsers;
  final GetProcessById _getProcessById;

  ProcessController(this._getUsers, this._getProcessById);

  final RxMap<int, SelectedUserEntity> selectedUsers =
      <int, SelectedUserEntity>{}.obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingProcess = false.obs;

  final Rxn<ProcessResponseEntity> process = Rxn<ProcessResponseEntity>();

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

  Future<ProcessResponseEntity?> fetchProcessById(int id) async {
    isLoadingProcess.value = true;
    errorMessage.value = '';

    final result = await _getProcessById(id);

    ProcessResponseEntity? loadedProcess;

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        process.value = null;

        AppToast.error("Erro ao carregar processo: ${failure.message}");
      },
      (success) {
        loadedProcess = success;
        process.value = success;

        setInitialSelectedProcessAuthors(success.authors);
      },
    );

    isLoadingProcess.value = false;

    return loadedProcess;
  }

  int? getProcessIdFromArguments() {
    final args = Get.arguments;

    if (args is Map) {
      final value = args['processId'];

      if (value is int) return value;

      if (value is String) {
        return int.tryParse(value);
      }
    }

    if (args is int) {
      return args;
    }

    return null;
  }

  bool getIsEditModeFromArguments() {
    final args = Get.arguments;

    if (args is Map) {
      return args['isEditMode'] == true;
    }

    return false;
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

    final result = await _getUsers(values);

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

    final result = await _getUsers(values);

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

  void clearProcessState() {
    process.value = null;
    selectedUsers.clear();
    errorMessage.value = '';
  }
}