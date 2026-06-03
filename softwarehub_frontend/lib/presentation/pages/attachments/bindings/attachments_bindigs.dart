import 'package:get/get.dart';
import '../../../../domain/repositories/iattachment_repository.dart';
import '../../../../domain/usecases/attachments/get_attachments.dart';
import '../../../../domain/usecases/attachments/open_attachment.dart';
import '../../../../domain/usecases/attachments/upload_file.dart';
import '../../../../infra/core/network/api_client.dart';
import '../../../../infra/datasources/attachment_datasource.dart';
import '../../../../infra/repositories/attachment_repository_impl.dart';
import '../../../core/bindigs/core_bindings.dart';
import '../controllers/attachments_controller.dart';

class AttachmentsBindigs extends Bindings {
  @override
  void dependencies() {
    CoreBinding.dependencies();

    Get.lazyPut<IAttachmentDatasource>(
      () => AttachmentDataSourceImpl(Get.find<ApiClient>()),
    );
    Get.lazyPut<IAttachmentRepository>(
      () => AttachmentRepositoryImpl(
        remoteDataSource: Get.find<IAttachmentDatasource>(),
      ),
    );
    Get.lazyPut<OpenAttachmentUseCase>(
      () => OpenAttachmentUseCase(Get.find<IAttachmentRepository>()),
    );
    Get.lazyPut<GetAttachments>(
      () => GetAttachments(Get.find<IAttachmentRepository>()),
    );
    Get.lazyPut<UploadFile>(
      () => UploadFile(Get.find<IAttachmentRepository>()),
    );
    Get.lazyPut<AttachmentController>(
      () => AttachmentController(
        Get.find<OpenAttachmentUseCase>(),
        Get.find<GetAttachments>(),
        Get.find<UploadFile>(),
      ),
    );
  }
}
