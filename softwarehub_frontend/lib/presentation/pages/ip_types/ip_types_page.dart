import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/ip_type_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/ip_types/controllers/ip_types_controller.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/process_page.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';

import '../consent_term/controllers/consent_term_controller.dart';

class SecondStageProcess {
  final FirstStageProcess firstStageProcess;
  final IpTypeEntity item;
  final bool isEdit;
  final String? originalIpTypeId;
  final Map<String, dynamic>? originalFormData;

  SecondStageProcess({
    required this.firstStageProcess,
    required this.item,
    this.isEdit = false,
    this.originalIpTypeId,
    this.originalFormData,
  });
}

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;

  _DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const spacing = 80.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

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
      backgroundColor: Color(0xFFCBD5E1),
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

      body: Stack(
        children: [
          // Textura de Fundo
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: Colors.black.withOpacity(0.04),
              ),
            ),
          ),

          // Conteúdo Principal
          Positioned.fill(
            child: Padding(
              padding: Responsive.getPadding(context),
              child: Obx(() {
                if (ipTypesController.isLoading.value) {
                  return const _LoadingState();
                }

                final list = ipTypesController.ipTypes.toList();
                if (list.isEmpty) {
                  return const _EmptyState(
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
                        padding: const EdgeInsets.fromLTRB(
                          4,
                          24,
                          4,
                          32,
                        ), // Aumentei o padding superior para descolar do AppBar
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 600,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
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
                                          color: _backgroundColor.withOpacity(
                                            0.9,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            _ResponsiveGrid(
                              columns: columns,
                              gap: 20,
                              children: list.map((item) {
                                return _IpTypeCard(
                                  title: item.name,
                                  dominantColor: _backgroundColor,
                                  onTap: () {
                                    final secondStageProcess =
                                        SecondStageProcess(
                                          firstStageProcess: auxProcess,
                                          item: item,
                                          isEdit: auxProcess.isEdit,
                                          originalIpTypeId:
                                              auxProcess.originalIpTypeId,
                                          originalFormData:
                                              auxProcess.originalFormData,
                                        );

                                    Get.toNamed(
                                      '/consent-term-check',
                                      arguments: {
                                        'ipTypeId': secondStageProcess.item.id,
                                        'nextRoute': '/process/ip_types/form',
                                        'nextArguments': secondStageProcess,
                                      },
                                    );

                                    /*Get.toNamed(
                                      "/process/ip_types/form",
                                      arguments: secondStageProcess,
                                    );*/
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
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: IpTypesPage._backgroundColor,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Carregando categorias...",
            style: TextStyle(
              color: IpTypesPage._backgroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const _EmptyState({required this.title, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.saved_search_rounded,
            size: 64,
            color: IpTypesPage._backgroundColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: IpTypesPage._backgroundColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: IpTypesPage._backgroundColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: IpTypesPage._backgroundColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Tentar novamente"),
            ),
          ],
        ],
      ),
    );
  }
}

class _IpTypeCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color dominantColor;

  const _IpTypeCard({
    required this.title,
    required this.onTap,
    required this.dominantColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const double borderRadiusValue = 16.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          splashColor: dominantColor.withOpacity(0.06),
          highlightColor: dominantColor.withOpacity(0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dominantColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.folder_special_outlined,
                    color: dominantColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3748),
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final int columns;
  final double gap;
  final List<Widget> children;

  const _ResponsiveGrid({
    required this.columns,
    required this.gap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (columns <= 1) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) SizedBox(height: gap),
          ],
        ],
      );
    }

    final rows = (children.length / columns).ceil();

    return Column(
      children: List.generate(rows, (r) {
        final start = r * columns;
        final end = (start + columns).clamp(0, children.length);
        final rowItems = children.sublist(start, end);

        return Padding(
          padding: EdgeInsets.only(bottom: r == rows - 1 ? 0 : gap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(columns, (c) {
              final idx = start + c;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: c == columns - 1 ? 0 : gap),
                  child: idx < children.length
                      ? rowItems[c]
                      : const SizedBox.shrink(),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
