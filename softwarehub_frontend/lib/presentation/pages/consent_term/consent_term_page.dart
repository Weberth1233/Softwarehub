import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'controllers/consent_term_controller.dart';

class ConsentTermPage extends GetView<ConsentTermController> {
  const ConsentTermPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int ipTypeId = Get.arguments['ipTypeId'];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.consentTerm.value == null && !controller.isLoading.value) {
        controller.fetchConsentTermByIpTypesId(ipTypeId);
      }
    });

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFCBD5E1),
        automaticallyImplyLeading: false,
        toolbarHeight: 74,
        titleSpacing: 12,
        title: Row(
          children: [
            SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: Colors.grey.shade900),
                  onPressed: () => Get.back(),
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Textos do Header integrados ao AppBar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Termo de Consentimento",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        final consentTerm = controller.consentTerm.value;

        if (consentTerm == null) {
          return const Center(
            child: Text('Nenhum termo encontrado.'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1F3A5F),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Termo de Consentimento',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Versão ${consentTerm.version}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: SelectableText(
                          consentTerm.content,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),

                    const Divider(height: 1),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Obx(
                            () => CheckboxListTile(
                              value: controller.accepted.value,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Li e aceito os termos apresentados acima.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onChanged: (value) {
                                controller.accepted.value = value ?? false;
                              },
                            ),
                          ),

                          const SizedBox(height: 16),

                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: controller.accepted.value
                                    ? () {
                                        Get.snackbar(
                                          'Termo aceito',
                                          'Você aceitou o termo de consentimento.',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );

                                        Get.back(result: true);
                                      }
                                    : null,
                                child:  Text(
                                  'Aceitar e continuar',
                                  style: textTheme.bodyMedium!.copyWith(color: Colors.white60),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}