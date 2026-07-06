import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'controllers/justification_controller.dart';
import 'widgets/attachment_picker_card.dart';
import '../../shared/widgets/shared_background.dart';

class JustificationPage extends GetView<JustificationController> {
  const JustificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    final args = (Get.arguments as Map<String, dynamic>?) ?? {};

    // Usamos ?? 0 para garantir que idProcess tenha um valor, mesmo que dê erro na rota
    final int idProcess = args['processId'] ?? 0;
    final int? justificationId = args['justificationId'];
    final String? reason = args['reason'];
    final String? attachmentFileName = args['attachmentFileName'];

    final bool isEditMode = justificationId != null;

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (isEditMode &&
        reason != null &&
        controller.reasonController.text.isEmpty) {
      controller.reasonController.text = reason;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.onSecondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: colors.primary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          isEditMode ? "Editar Justificativa" : "Justificativa",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFCBD5E1),

      body: SharedBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            Responsive.getPadding(context).left,
            20,
            Responsive.getPadding(context).right,
            24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.onSecondary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colors.primary.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Correção / Justificativa",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colors.tertiary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isEditMode
                            ? "Atualize a justificativa do processo #$idProcess."
                            : "Explique o motivo da correção para o processo #$idProcess.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.secondary,
                        ),
                      ),
                      const SizedBox(height: 18),

                      CustomTextField(
                        controller: controller.reasonController,
                        label: "Justificativa",
                        maxLines: 12,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, insira uma justificativa.';
                          }
                          if (value.trim().length < 10) {
                            return 'A justificativa deve ter pelo menos 10 caracteres.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      AttachmentPickerCard(
                        isEditMode: isEditMode,
                        currentAttachmentFileName: attachmentFileName,
                      ),

                      const SizedBox(height: 18),

                      Obx(() {
                        return SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                              if (!controller.formKey.currentState!
                                  .validate()) {
                                return;
                              }

                              if (isEditMode) {
                                controller.put(
                                  justificationId: justificationId,
                                  idProcess: idProcess,
                                );
                              } else {
                                controller.post(idProcess);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              disabledBackgroundColor:
                              colors.primary.withOpacity(0.55),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              isEditMode ? "Atualizar" : "Enviar",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}