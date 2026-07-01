import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/widgets/shared_background.dart';
import 'controllers/application_field_controller.dart';
import 'widgets/application_field_area_tile.dart';
import 'widgets/application_field_empty_state.dart';
import 'widgets/application_field_header_card.dart';
import 'widgets/application_field_pagination.dart';
import 'widgets/application_field_search_card.dart';
import 'widgets/application_field_selection_bar.dart';

class ApplicationFieldPage extends GetView<ApplicationFieldController> {
  const ApplicationFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // 1. Fundo claro padrão para destacar os cards brancos
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 80, // Aumentado levemente para o subtítulo
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
                  color: colors.onSecondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: colors.onSecondary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return Text(
                controller.screenTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  fontSize: 20,
                ),
              );
            }),
            const SizedBox(height: 2),
            Text(
              "Gerencie áreas e campos cadastrados",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSecondary.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      // 2. Protegemos as cores dos componentes, mas mantivemos o seu SharedBackground
      body: SharedBackground(
        child: Obx(() {
          if (controller.isLoadingList.value &&
              controller.applicationFields.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: colors.primary),
            );
          }

          if (controller.errorMessage.value.isNotEmpty &&
              controller.applicationFields.isEmpty) {
            return _buildErrorState(context);
          }

          final grouped = controller.groupedByApplicationArea;
          final areas = grouped.keys.toList();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ApplicationFieldHeaderCard(
                          totalAreas: areas.length,
                          totalFields: controller.applicationFields.length,
                          totalSelected: controller.selectedFieldIds.length,
                          isDesktop: isDesktop,
                        ),

                        const SizedBox(height: 20),

                        ApplicationFieldSearchCard(controller: controller),

                        const SizedBox(height: 20),

                        // 3. Lista de Áreas renderizada ANTES da barra de seleção
                        if (controller.applicationFields.isEmpty)
                          const ApplicationFieldEmptyState()
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: areas.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final areaName = areas[index];
                              final fields = grouped[areaName] ?? [];

                              return ApplicationFieldAreaTile(
                                areaName: areaName,
                                fields: fields,
                                controller: controller,
                              );
                            },
                          ),

                        const SizedBox(height: 20),

                        // 4. Barra de Seleção na posição correta (fim da lista)
                        ApplicationFieldSelectionBar(controller: controller),

                        const SizedBox(height: 24),

                        ApplicationFieldPagination(controller: controller),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: colors.error),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: colors.primary, // Ajustado para contrastar com fundo claro
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => controller.fetchApplicationFields(),
              style: TextButton.styleFrom(backgroundColor: colors.primary),
              child: Text(
                "Tentar novamente",
                style: TextStyle(
                  color: colors.onSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}