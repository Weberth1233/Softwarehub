import 'package:get/get_navigation/get_navigation.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process_royalty_distribution/bindings/process_royalty_distribution_binding.dart';
import '../../middlewares/auth_middleware.dart';
import '../../pages/attachments/attachments_page.dart';
import '../../pages/attachments/bindings/attachments_bindigs.dart';
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
import '../../pages/auth/login/bindings/login_bindings.dart';
import '../../pages/ip_types/ip_types_page.dart';
import '../../pages/justifications/bindings/justification_bindings.dart';
import '../../pages/justifications/justification_page.dart';
import '../../pages/nice_classification/bindings/nice_classification_binding.dart';
import '../../pages/nice_classification/nice_classification_page.dart';
import '../../pages/process/bindings/external_author_bindigs.dart'
    show ExternalAuthorBindigs;
import '../../pages/process/bindings/process_detail_bindings.dart';
import '../../pages/process/bindings/user_bindings.dart';
import '../../pages/process/process_detail_page.dart';
import '../../pages/process/process_external_author_form_page.dart';
import '../../pages/process/process_external_author_page.dart';
import '../../pages/process/process_page.dart';
import '../../pages/process_royalty_distribution/process_royalty_distribution_page.dart';
import '../../pages/unauthenticated_page.dart';

class MyRoutes {
  static String get initialRoute => '/';

  static List<GetPage> get pages => [
    GetPage(name: '/', page: () => LoginPage(), binding: LoginBindings()),
    GetPage(
      name: "/register",
      page: () => RegisterPage(),
      binding: RegisterBindings(),
    ),

    GetPage(
      name: "/forgot-password",
      page: () => ForgotPasswordPage(),
      binding: ForgotPasswordBindings(),
    ),
    GetPage(
      name: "/password-reset",
      page: () => PasswordResetPage(),
      binding: PasswordResetBindings(),
    ),

    GetPage(
      name: "/home",
      page: () => HomePage(),
      binding: HomeBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: "/user-logged",
      page: () => RegisterPage(isEditMode: true),
      binding: RegisterBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: "/process",
      page: () => ProcessPage(),
      binding: UserBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: "/process-edit",
      page: () => ProcessPage(isEditMode: true),
      binding: UserBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: "/process/process-external-author",
      page: () => ProcessExternalAuthorPage(),
      binding: ExternalAuthorBindigs(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: "/process/process-external-author/forms",
      page: () => ProcessExternalAuthorFormPage(),
      binding: ExternalAuthorBindigs(),
      middlewares: [AuthMiddleware()],
    ),

    // Rota da Tela A (Detalhes)
    GetPage(
      name: "/home/process-detail/:id",
      page: () => ProcessDetailPage(),
      binding: ProcessDetailBindings(),
      preventDuplicates: false,
      middlewares: [AuthMiddleware()],
    ),

    // Rota da Tela B (Cotas)
    GetPage(
      name: "/home/process-detail/:id/royalty-distribution",
      page: () => ProcessRoyaltyDistributionPage(),
      binding: ProcessRoyaltyDistributionBindings(), // O seu binding das cotas
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: "/home/process-detail/:id/attachments",
      page: () => AttachmentsPage(),
      binding: AttachmentsBindigs(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: "/home/process-detail/:id/justification",
      page: () => JustificationPage(),
      binding: JustificationBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/process/ip-types',
      page: () => IpTypesPage(),
      binding: IpTypesBindings(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/process/ip-types/form',
      page: () => IpTypesForm(),
      binding: IpTypesFormBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/consent-term',
      page: () => const ConsentTermPage(),
      binding: ConsentTermBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(
      name: '/consent-term-check',
      page: () => const ConsentTermCheckPage(),
      binding: ConsentTermBinding(),
      middlewares: [AuthMiddleware()],
    ),

   /* GetPage(
      name: '/consent-term',
      page: () => const ConsentTermPage(),
      binding: ConsentTermBinding(),
      middlewares: [AuthMiddleware()],
    ),*/

    GetPage(
      name: '/home/process-detail/:id/nice-classification',
      page: () => const NiceClassificationPage(),
      binding: NiceClassificationBinding(),
      middlewares: [AuthMiddleware()],
    ),

    GetPage(name: '/unauthenticated', page: () => const UnauthenticatedPage()),
  ];
}
