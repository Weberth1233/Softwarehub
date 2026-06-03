import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../infra/core/network/api_client.dart';
import '../../../infra/datasources/auth_local_datasource.dart';

class CoreBinding {
  static void dependencies() {
    Get.lazyPut<http.Client>(
      () => http.Client(),
      fenix: true,
    );

    Get.lazyPut<ApiClient>(
      () => ApiClient(Get.find<http.Client>()),
      fenix: true,
    );

    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSource(),
      fenix: true,
    );
  }
}