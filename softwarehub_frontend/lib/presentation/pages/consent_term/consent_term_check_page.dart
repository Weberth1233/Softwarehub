import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/consent_term_controller.dart';

class ConsentTermCheckPage extends GetView<ConsentTermController> {
  const ConsentTermCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;

    final int ipTypeId = args['ipTypeId'];
    final String nextRoute = args['nextRoute'];
    final dynamic nextArguments = args['nextArguments'];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final alreadyAccepted = await controller.prepareConsentTermScreen(ipTypeId);

      final consentTerm = controller.consentTerm.value;

      if (controller.errorMessage.value.isNotEmpty) {
        Get.snackbar(
          'Erro',
          controller.errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.back();
        return;
      }

      if (alreadyAccepted) {
        Get.offNamed(
          nextRoute,
          arguments: nextArguments,
        );
        return;
      }

      Get.offNamed(
        '/consent-term',
        arguments: {
          'consentTerm': consentTerm,
          'nextRoute': nextRoute,
          'nextArguments': nextArguments,
        },
      );
    });

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(height: 24),
              Text(
                'Verificando termo de consentimento',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aguarde enquanto verificamos se este termo já foi aceito.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}