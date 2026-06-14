import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/widgets/diagonal_lines_painter.dart';
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: colors.primary,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Campos de Aplicação",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: colors.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalLinesPainter(
                color: colors.onSecondary.withOpacity(0.04),
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoadingList.value &&
                controller.applicationFields.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: colors.onSecondary,
                ),
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
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ApplicationFieldHeaderCard(
                            totalAreas: areas.length,
                            totalFields: controller.applicationFields.length,
                            isDesktop: isDesktop,
                          ),

                          const SizedBox(height: 20),

                          ApplicationFieldSearchCard(
                            controller: controller,
                          ),

                          const SizedBox(height: 14),

                          ApplicationFieldSelectionBar(
                            controller: controller,
                          ),

                          const SizedBox(height: 20),

                          if (controller.applicationFields.isEmpty)
                            const ApplicationFieldEmptyState()
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: areas.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
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

                          ApplicationFieldPagination(
                            controller: controller,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
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
            Icon(
              Icons.error_outline,
              size: 60,
              color: colors.error,
            ),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: colors.onSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => controller.fetchApplicationFields(),
              style: TextButton.styleFrom(
                backgroundColor: colors.onSecondary,
              ),
              child: Text(
                "Tentar novamente",
                style: TextStyle(
                  color: colors.primary,
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