import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../infra/datasources/auth_local_datasource.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/shared_background.dart';
import '../users/controllers/user_logged_controller.dart';
import 'controllers/home_controller.dart';
import 'widgets/custom_menu.dart';
import 'widgets/filter_card.dart';
import 'widgets/footer.dart';
import 'widgets/header_card.dart';
import 'widgets/process_card.dart';
import 'widgets/status_label.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final processController = Get.find<ProcessController>();

  final authLocalDataSource = Get.find<AuthLocalDataSource>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CustomMenu(),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: UnifiedBackgroundPainter(
                color: theme.colorScheme.primary.withOpacity(0.08),
                icon: Icons.rocket_launch_outlined,
              ),
            ),
          ),
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: Responsive.getPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(33),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.40),
                            blurRadius: 8,
                            offset: const Offset(0, 9),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HeaderCard(processController: processController,),
                          const SizedBox(height: 32),
                          StatusLabel(processController: processController),
                          const SizedBox(height: 32),
                          const FilterCard(),
                          const SizedBox(height: 24),
                          Obx(() {
                            final list = processController.processes.toList();
                            if (processController.isLoadingList.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (list.isEmpty) {
                              return Center(
                                child: Text(
                                  "Sem resultados!",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    spacing: 20,
                                    runSpacing: 20,
                                    children: list
                                        .map((item) => ProcessCard(item: item))
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Obx(() {
                                  final current =
                                      processController.currentPage.value;
                                  final total =
                                      processController.totalPages.value;
                                  if (total <= 1) return const SizedBox();
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: current > 0
                                            ? processController.previousPage
                                            : null,
                                        child: Text(
                                          "Anterior",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        "Página ${current + 1} de $total",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: current < total - 1
                                            ? processController.nextPage
                                            : null,
                                        child: Text(
                                          "Próxima",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Footer(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
