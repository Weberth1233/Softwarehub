import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/process/process_request_entity.dart';
import 'package:nit_sgpi_frontend/domain/usecases/process/post_process.dart';
import 'package:nit_sgpi_frontend/domain/usecases/process/put_process.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/app_routes.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/app_toast.dart';

import '../../../../domain/core/errors/failures.dart';

class ProcessPostController extends GetxController{
  final PostProcess _postProcess;
  final PutProcess _putProcess;

  ProcessPostController(this._postProcess, this._putProcess);
  RxBool isLoading = false.obs;
  RxString message = "".obs;

  Future<void> post(ProcessRequestEntity entity) async {
  if (isLoading.value) return;

  isLoading.value = true;
  message.value = '';

  final result = await _postProcess(entity);

  result.fold(
    (Failure failure) {
      AppToast.error(failure.message);
    },
    (int id) {
      // final route = '/home/process-detail/$id/royalty-distribution';
      final route = AppRoutes.processRoyaltyDistributionById(id);

      debugPrint('ID CRIADO NO POST: $id');
      debugPrint('ROTA CHAMADA: $route');

      Get.toNamed(
        route,
        arguments: {
          'processId': id,
          'openedFromProcessFlow': true,
        },
      );

      AppToast.success("Sucesso - Formulário enviado com sucesso!");
    },
  );

  isLoading.value = false;
}

  Future<void> put(int processId, ProcessRequestEntity entity) async {
    if (isLoading.value) return;
    isLoading.value = true;
    message.value = '';
    final result = await _putProcess(
      processId,
      entity
    );
    result.fold(
      (Failure failure) {
        AppToast.error(failure.message);
      },
      (sucess) {
        AppToast.success("Sucesso - Formulário enviado com sucesso!");
        message.value = sucess;
      },
    );
    isLoading.value = false;
  }
}