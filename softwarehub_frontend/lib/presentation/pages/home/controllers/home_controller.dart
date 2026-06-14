import 'package:get/get.dart';
import '../../../../domain/core/errors/failures.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../domain/entities/process/process_status_count_entity.dart';
import '../../../../domain/usecases/process/delete_process.dart';
import '../../../../domain/usecases/process/get_process.dart';
import '../../../../domain/usecases/process/get_process_status_count.dart';
import '../../../shared/utils/app_toast.dart';

class ProcessController extends GetxController {
  final GetProcesses _getProcesses;
  final GetProcessStatusCount _getProcessStatusCount;
  final DeleteProcess _deleteProcess;

  ProcessController(
    this._getProcesses,
    this._getProcessStatusCount,
    this._deleteProcess,
  );

  final RxBool isLoadingList = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isLoadingProcessCount = false.obs;

  final RxString errorMessage = ''.obs;

  final RxList<ProcessResponseEntity> processes = <ProcessResponseEntity>[].obs;
  final RxList<ProcessStatusCountEntity> processesStatus =
      <ProcessStatusCountEntity>[].obs;

  final RxString title = ''.obs;
  final RxString status = ''.obs;

  final RxInt currentPage = 0.obs;
  final RxInt totalPages = 0.obs;

  final int size = 10;

  @override
  void onInit() {
    super.onInit();
    fetchProcesses();
    processStatusCount();
  }

  Future<void> fetchProcesses({int page = 0}) async {
    if (isLoadingList.value) return;

    isLoadingList.value = true;

    final result = await _getProcesses(
      title: title.value,
      statusGenero: status.value,
      page: page,
      size: size,
    );

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (pagedResult) {
        processes.assignAll(pagedResult.content);

        currentPage.value = pagedResult.number;
        totalPages.value = pagedResult.totalPages;
      },
    );

    isLoadingList.value = false;
  }


  void nextPage() {
    if (currentPage.value < totalPages.value - 1) {
      fetchProcesses(page: currentPage.value + 1);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      fetchProcesses(page: currentPage.value - 1);
    }
  }

  void goToPage(int page) {
    fetchProcesses(page: page);
  }

  void searchByTitle(String value) {
    title.value = value;
    fetchProcesses(page: 0);
  }

  void filterByStatus(String newStatus) {
    status.value = newStatus;
    fetchProcesses(page: 0);
  }

  Future<void> processStatusCount() async {
    if (isLoadingProcessCount.value) return;

    isLoadingProcessCount.value = true;

    final result = await _getProcessStatusCount();

    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (list) {
        processesStatus.assignAll(list);
      },
    );

    isLoadingProcessCount.value = false;
  }

  Future<void> deleteProcessById(int id) async {
    if (isDeleting.value) return;

    isDeleting.value = true;

    final result = await _deleteProcess(id);

    await result.fold(
      (Failure failure) async {
        AppToast.error(failure.message);
      
      },
      (message) async {
        await fetchProcesses(page: 0);
        await processStatusCount();
        AppToast.success(message);
      },
    );

    isDeleting.value = false;
  }
}