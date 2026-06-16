// lib/presentation/core/routes/app_routes.dart

class AppRoutes {
  AppRoutes._();

  static const String initial = '/';

  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String passwordReset = '/password-reset';

  static const String home = '/home';
  static const String userLogged = '/user-logged';

  // Processo
  static const String process = '/home/process';


  static const String processExternalAuthor =
      '/home/process/process-external-author';

  static const String processExternalAuthorForm =
      '/home/process/process-external-author/forms';

  static const String ipTypes = '/home/process/ip-types';

  static const String ipTypesForm = '/home/process/ip-types/form';

  // Detalhes do processo
  // Antes era: /home/process-detail/:id
  // Agora é:  /home/process/:id
  static const String processDetail = '/home/process/:id';

  static const String processRoyaltyDistribution =
      '/home/process/:id/royalty-distribution';

  static const String processAttachments =
      '/home/process/:id/attachments';

  static const String processJustification =
      '/home/process/:id/justification';

  static const String processNiceClassification =
      '/home/process/:id/nice-classification';

  static const String processApplicationField =
      '/home/process/:id/application-field';

  // Termos
  static const String consentTerm = '/consent-term';

  static const String consentTermCheck = '/consent-term-check';

  static const String unauthenticated = '/unauthenticated';

  // Rotas com ID
  static String processDetailById(int id) =>
      '/home/process/$id';

  static String processRoyaltyDistributionById(int id) =>
      '/home/process/$id/royalty-distribution';

  static String processAttachmentsById(int id) =>
      '/home/process/$id/attachments';

  static String processJustificationById(int id) =>
      '/home/process/$id/justification';

  static String processNiceClassificationById(int id) =>
      '/home/process/$id/nice-classification';

  static String processApplicationFieldById(int id) =>
      '/home/process/$id/application-field';
}