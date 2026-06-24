import 'package:get/get.dart';
import '../../../../domain/entities/external_author_entity.dart';
import '../../../../domain/usecases/external_author/delete_external_author.dart';
import '../../../../domain/usecases/external_author/get_external_authors.dart';
import '../../../../domain/usecases/external_author/post_external_author.dart';
import '../../../../domain/usecases/external_author/put_external_author.dart';
import '../../../shared/utils/app_toast.dart';

class ProcessExternalAuthorController extends GetxController {
  final GetExternalAuthors _getExternalAuthors;
  final PostExternalAuthor _postExternalAuthor;
  final DeleteExternalAuthor _deleteExternalAuthor;
  final PutExternalAuthor _putExternalAuthor;

  ProcessExternalAuthorController(
    this._getExternalAuthors,
    this._postExternalAuthor,
    this._deleteExternalAuthor,
    this._putExternalAuthor,
  );

  final RxMap<int, ExternalAuthorEntity> selectedExternalAuthor =
      <int, ExternalAuthorEntity>{}.obs;

  final RxBool isLoading = false.obs;
  final RxList<ExternalAuthorEntity> externalAuthors =
      <ExternalAuthorEntity>[].obs;
  final RxString errorMessage = ''.obs;
  final RxString message = "".obs;
  final RxString searchFilter = ''.obs;

  final RxInt page = 0.obs;
  final int size = 9;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExternalAuthors();
  }

  void toggleUser(ExternalAuthorEntity user) {
    if (user.id == null) return;

    if (selectedExternalAuthor.containsKey(user.id)) {
      selectedExternalAuthor.remove(user.id);
    } else {
      selectedExternalAuthor[user.id!] = user;
    }
  }

  void removeUserById(int id) {
    selectedExternalAuthor.remove(id);
  }

  void search(String query) {
    searchFilter.value = query;
    fetchExternalAuthors(loadMore: false);
  }

  Future<void> fetchExternalAuthors({bool loadMore = false}) async {
    if (isLoading.value || (loadMore && !hasMore.value)) return;

    isLoading.value = true;
    errorMessage.value = '';

    if (loadMore) {
      page.value++;
    } else {
      page.value = 0;
      externalAuthors.clear();
      hasMore.value = true;
    }

    final values = <String, String>{
      'page': page.toString(),
      'page-size': size.toString(),
    };

    if (searchFilter.value.trim().isNotEmpty) {
      values['search'] = searchFilter.value.trim();
    }

    final result = await _getExternalAuthors(values);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        if (loadMore && page.value > 0) page.value--;
      },
      (pagedResult) {
        externalAuthors.assignAll(pagedResult.content);
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

    final result = await _getExternalAuthors(values);
    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        page.value++;
      },
      (pagedResult) {
        externalAuthors.assignAll(pagedResult.content);
        hasMore.value = true;
      },
    );

    isLoading.value = false;
  }

  Future<bool> postExternalAuthor(ExternalAuthorEntity entity) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _postExternalAuthor(entity);

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
        return false;
      },
      (success) async {
        message.value = success;
        await fetchExternalAuthors(loadMore: false);
        isLoading.value = false;
        return true; // SUCESSO!
      },
    );
  }

  Future<void> deleteExternalAuthor(int id) async {
    try {
      isLoading.value = true;

      final result = await _deleteExternalAuthor(id);

      result.fold(
        (failure) {
          AppToast.error("Erro - ${failure.message}");
        },
        (successMessage) {
          externalAuthors.removeWhere((element) => element.id == id);
          selectedExternalAuthor.remove(id);
          AppToast.success("Sucesso - Registro removido com sucesso");
        },
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateExternalAuthor(int id, ExternalAuthorEntity entity) async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _putExternalAuthor(id, entity);

    return result.fold(
      (failure) {
        errorMessage.value = failure.message;
        isLoading.value = false;
        return false;
      },
      (success) async {
        message.value = success;
        await fetchExternalAuthors(loadMore: false);
        isLoading.value = false;
        return true; // SUCESSO!
      },
    );
  }
}
