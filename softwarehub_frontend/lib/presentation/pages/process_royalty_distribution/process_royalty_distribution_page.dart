import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/process_royalty_distribution_controller.dart';
import 'widgets/royalty_summary_card.dart';
import 'widgets/share_readonly_card.dart';

class ProcessRoyaltyDistributionPage
    extends GetView<ProcessRoyaltyDistributionController> {
  const ProcessRoyaltyDistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final bool isEditMode = controller.isEditMode.value;

      return Scaffold(
        backgroundColor: colorScheme.onSecondary,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          centerTitle: false,
          leading: !controller.openedFromProcessFlow.value
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 46,
                      width: 46,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colorScheme.onSecondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.arrow_back,
                            color: colorScheme.primary,
                          ),
                          onPressed: () {
                            final process = controller.process.value;

                            if (process != null) {
                              Get.back(result: process.id);
                            } else {
                              Get.back();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          title: Text(
            isEditMode
                ? "Editar distribuição de cotas"
                : "Distribuição de cotas",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              fontSize: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Obx(
                  () => RoyaltySummaryCard(
                    processId: controller.processId,
                    processTitle: controller.processTitle,
                    totalPercentage: controller.totalPercentage,
                    remainingPercentage: controller.remainingPercentage,
                    isValid: controller.isTotalValid,
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.shares.isEmpty) {
                      return Center(
                        child: Text(
                          "Nenhuma cota encontrada.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.secondary,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: controller.shares.length,
                      itemBuilder: (context, index) {
                        final share = controller.shares[index];

                        return ShareReadonlyCard(
                          key: ValueKey(share.id),
                          index: index,
                          share: share,
                          onSliderChanged: (value) => controller
                              .updatePercentage(index, value, fromText: false),
                          onTextChanged: (value) => controller.updatePercentage(
                            index,
                            value,
                            fromText: true,
                          ),
                          onRequestUniversityChange:
                              controller.requestUniversityChange,
                        );
                      },
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.onSurface.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submit,
                        icon: controller.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                isEditMode ? Icons.save_as : Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                        label: Text(
                          controller.isLoading.value
                              ? "Salvando..."
                              : isEditMode
                              ? "Atualizar distribuição"
                              : "Salvar distribuição",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}