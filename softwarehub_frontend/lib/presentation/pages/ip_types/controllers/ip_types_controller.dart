import 'package:get/state_manager.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_type_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/ip_types/get_iptypes.dart';

import '../../../../domain/core/errors/failures.dart';

class IpTypesController extends GetxController {
  final GetIpTypes getIptypes;

  IpTypesController(this.getIptypes);
  final RxBool isLoading = false.obs;

  final RxList<IpTypeEntity> ipTypes = <IpTypeEntity>[].obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchIpTypes();
  }

  Future<void> fetchIpTypes() async {
    if (isLoading.value) return;
    isLoading.value = true;
    final result = await getIptypes();
    result.fold(
      (Failure failure) {
        errorMessage.value = failure.message;
      },
      (pagedResult) {
        ipTypes.value = pagedResult;
      },
    );
    isLoading.value = false;
  }
}
