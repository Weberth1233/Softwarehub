import 'package:get/get.dart';

import '../../../domain/entities/process/process_response_entity.dart';
import 'app_routes.dart';

import 'package:nit_sgpi_frontend/presentation/pages/application_field/application_field_page.dart';
import 'package:nit_sgpi_frontend/presentation/pages/application_field/bindings/application_field_bindings.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process_royalty_distribution/bindings/process_royalty_distribution_binding.dart';

import '../../middlewares/auth_middleware.dart';
import '../../pages/attachments/attachments_page.dart';
import '../../pages/attachments/bindings/attachments_bindigs.dart';
import '../../pages/auth/login/bindings/login_bindings.dart';
import '../../pages/auth/login/login_page.dart';
import '../../pages/auth/password_reset/bindings/forgot_password_bindings.dart';
import '../../pages/auth/password_reset/bindings/password_reset_bindings.dart';
import '../../pages/auth/password_reset/forgot_password_page.dart';
import '../../pages/auth/password_reset/password_reset_page.dart';
import '../../pages/auth/register/bindings/register_bindings.dart';
import '../../pages/auth/register/register_page.dart';
import '../../pages/consent_term/bindings/consent_term_binding.dart';
import '../../pages/consent_term/consent_term_check_page.dart';
import '../../pages/consent_term/consent_term_page.dart';
import '../../pages/home/bindings/home_bindings.dart';
import '../../pages/home/home_page.dart';
import '../../pages/ip_types/bindings/ip_types_bindings.dart';
import '../../pages/ip_types/bindings/ip_types_form_binding.dart';
import '../../pages/ip_types/ip_types_form.dart';
import '../../pages/ip_types/ip_types_page.dart';
import '../../pages/justifications/bindings/justification_bindings.dart';
import '../../pages/justifications/justification_page.dart';
import '../../pages/nice_classification/bindings/nice_classification_binding.dart';
import '../../pages/nice_classification/nice_classification_page.dart';
import '../../pages/process/bindings/user_bindings.dart';
import '../../pages/process/process_page.dart';
import '../../pages/process_detail/bindings/process_detail_bindings.dart';
import '../../pages/process_detail/process_detail_page.dart';
import '../../pages/process_external_author/bindings/external_author_bindigs.dart'
    show ExternalAuthorBindigs;
import '../../pages/process_external_author/process_external_author_form_page.dart';
import '../../pages/process_external_author/process_external_author_page.dart';
import '../../pages/process_royalty_distribution/process_royalty_distribution_page.dart';
import '../../pages/unauthenticated_page.dart';

class MyRoutes {
  static String get initialRoute => AppRoutes.initial;

  static List<GetPage> get pages => [
    GetPage(
      name: AppRoutes.initial,
      page: () => LoginPage(),
      binding: LoginBindings(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPage(),
      binding: RegisterBindings(),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordPage(),
      binding: ForgotPasswordBindings(),
    ),

    GetPage(
      name: AppRoutes.passwordReset,
      page: () => PasswordResetPage(),
      binding: PasswordResetBindings(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.userLogged,
      page: () => RegisterPage(isEditMode: true),
      binding: RegisterBindings(),
      middlewares: [AuthMiddleware()],
    ),

    // Criar e editar processo na mesma rota
    GetPage(
      name: AppRoutes.process,
      page: () => ProcessPage(),
      binding: UserBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.processExternalAuthor,
      page: () => ProcessExternalAuthorPage(),
      binding: ExternalAuthorBindigs(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.processExternalAuthorForm,
      page: () => ProcessExternalAuthorFormPage(),
      binding: ExternalAuthorBindigs(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.ipTypes,
      page: () => IpTypesPage(),
      binding: IpTypesBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.ipTypesForm,
      page: () => IpTypesForm(),
      binding: IpTypesFormBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.consentTerm,
      page: () => const ConsentTermPage(),
      binding: ConsentTermBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.consentTermCheck,
      page: () => const ConsentTermCheckPage(),
      binding: ConsentTermBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.processRoyaltyDistribution,
      page: () => ProcessRoyaltyDistributionPage(),
      binding: ProcessRoyaltyDistributionBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.processAttachments,
      page: () => AttachmentsPage(),
      binding: AttachmentsBindigs(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.processJustification,
      page: () => JustificationPage(),
      binding: JustificationBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.processNiceClassification,
      page: () => const NiceClassificationPage(),
      binding: NiceClassificationBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: AppRoutes.processApplicationField,
      page: () => const ApplicationFieldPage(),
      binding: ApplicationFieldBindings(),
      middlewares: [AuthMiddleware()],
    ),

    // Rota genérica de detalhes fica depois das específicas
    GetPage(
      name: AppRoutes.processDetail,
      page: () => ProcessDetailPage(),
      binding: ProcessDetailBindings(),
      preventDuplicates: false,
      middlewares: [AuthMiddleware()],
    ),

   

    GetPage(
      name: AppRoutes.unauthenticated,
      page: () => const UnauthenticatedPage(),
    ),
  ];
}
