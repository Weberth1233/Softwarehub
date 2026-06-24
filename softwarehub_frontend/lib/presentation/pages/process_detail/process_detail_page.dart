import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/process/process_response_entity.dart';
import '../../../domain/entities/user/user_educational_institution_link_entity.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/utils/app_toast.dart';
import '../../shared/widgets/diagonal_lines_painter.dart';
import 'controllers/process_detail_controller.dart';
part 'widgets/process_detail_layout.dart';
part 'widgets/process_detail_menu.dart';
part 'widgets/process_detail_content.dart';
part 'widgets/process_detail_people.dart';
part 'widgets/process_detail_form.dart';
part 'widgets/process_detail_attachments.dart';
part 'widgets/process_detail_fixes.dart';
part 'widgets/process_detail_nice.dart';
part 'widgets/process_detail_royalties.dart';
part 'widgets/process_detail_status.dart';
part 'widgets/process_detail_shared.dart';
part 'widgets/process_detail_formatters.dart';
part 'widgets/process_detail_status_ui.dart';


class ProcessDetailPage extends StatefulWidget {
  const ProcessDetailPage({super.key});

  @override
  State<ProcessDetailPage> createState() => _ProcessDetailPageState();
}

class _ProcessDetailPageState extends State<ProcessDetailPage> {
  int _selectedIndex = 0;

  bool _isApproving = false;
  bool _isClassifying = false;
  bool _isDeletingJustification = false;

  ProcessDetailController get controller => Get.find<ProcessDetailController>();

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      final initialSectionIndex = args['initialSectionIndex'];

      if (initialSectionIndex is int) {
        _selectedIndex = initialSectionIndex;
      }
    }
  }

  Future<void> _runAction({
    required Future<void> Function() action,
    required void Function(bool value) setLoading,
  }) async {
    if (_isApproving || _isClassifying || _isDeletingJustification) return;

    setState(() => setLoading(true));

    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => setLoading(false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
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
                  icon: Icon(Icons.arrow_back, color: colors.primary),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Detalhes do Processo",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colors.onSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: colors.primary,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
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
                    style: TextStyle(color: colors.onSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      if (controller.process.value?.id != null) {
                        controller.fetchProcess(controller.process.value!.id);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: colors.onSecondary,
                    ),
                    child: Text(
                      "Tentar novamente",
                      style: TextStyle(color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.process.value == null) {
          return Center(
            child: Text(
              "Processo não encontrado.",
              style: TextStyle(color: colors.onSecondary),
            ),
          );
        }

        final entity = controller.process.value!;
        final dateFormatted = this._formatCreatedAt(entity.createdAt);

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: DiagonalLinesPainter(
                  color: colors.onSecondary.withOpacity(0.04),
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: this._buildProcessStatusBar(
                          context,
                          entity,
                          dateFormatted,
                          isDesktop,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1600),
                            child: isDesktop
                                ? this._buildWideMasterDetail(
                                    context,
                                    entity,
                                    controller,
                                    constraints.maxWidth,
                                  )
                                : this._buildNarrowMasterDetail(
                                    context,
                                    entity,
                                    controller,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
