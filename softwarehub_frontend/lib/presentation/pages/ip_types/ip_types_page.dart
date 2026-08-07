import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/ip_type_entity.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/shared_background.dart';
import '../process/models/first_stage_process.dart';
import 'controllers/ip_types_controller.dart';
import 'models/second_stage_process.dart';
import 'widgets/empty_state.dart';
import 'widgets/ip_type_card.dart';
import 'widgets/loading_state.dart';
import 'widgets/responsive_grid.dart';

class IpTypesPage extends StatelessWidget {
  const IpTypesPage({super.key});

  static const Color _backgroundColor = Color(0xFF004294);

  @override
  Widget build(BuildContext context) {
    final auxProcess = Get.arguments as FirstStageProcess;
    final ipTypesController = Get.find<IpTypesController>();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _backgroundColor,
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
                    "Categoria de propriedade intelectual",
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


      body: SharedBackground(
        child: Padding(
          padding: Responsive.getPadding(context),
          child: Obx(() {
            if (ipTypesController.isLoading.value) {
              return const LoadingState();
            }

            final list = ipTypesController.ipTypes.toList();
            if (list.isEmpty) {
              return const EmptyState(
                title: "Sem resultados",
                message: "Nenhuma categoria disponível no momento.",
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;

                // Grid responsiva
                final int columns = w >= 1100
                    ? 4
                    : w >= 840
                    ? 3
                    : w >= 600
                    ? 2
                    : 1;

                return Scrollbar(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(4, 24, 4, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.touch_app_rounded,
                                  size: 20,
                                  color: _backgroundColor.withOpacity(0.7),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    "Escolha e clique em uma categoria para avançar.",
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: _backgroundColor.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        ResponsiveGrid(
                          columns: columns,
                          gap: 20,
                          children: list.map((item) {
                            return IpTypeCard(
                              title: item.name,
                              dominantColor: _backgroundColor,
                              onTap: () {
                                final secondStageProcess = SecondStageProcess(
                                  firstStageProcess: auxProcess,
                                  item: item,
                                  isEdit: auxProcess.isEdit,
                                  originalIpTypeId:
                                  auxProcess.originalIpTypeId,
                                  originalFormData: auxProcess.originalFormData,
                                );

                                Get.toNamed(
                                  AppRoutes.consentTermCheck,
                                  arguments: {
                                    'ipTypeId': secondStageProcess.item.id,
                                    'nextRoute': AppRoutes.ipTypesForm,
                                    'nextArguments': secondStageProcess,
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}