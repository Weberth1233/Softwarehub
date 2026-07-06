import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/process/process_response_entity.dart';
import '../../../domain/entities/user/user_educational_institution_link_entity.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/utils/app_toast.dart';
import '../../shared/widgets/shared_background.dart'; // Novo fundo importado aqui
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

    // Nova cor de fundo baseada no design (um azul/cinza bem claro)
    final backgroundColor = const Color(0xFFE8EDF2);

    return Scaffold(
      backgroundColor: backgroundColor,
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
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            // Cor alterada para primary para dar contraste no fundo claro
            child: CircularProgressIndicator(color: colors.primary),
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
                    // Cor alterada para onBackground para ficar legível no fundo claro
                    style: TextStyle(color: colors.onBackground),
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
                      // Cores invertidas no botão para combinar com o tema claro
                      backgroundColor: colors.primary,
                    ),
                    child: Text(
                      "Tentar novamente",
                      style: TextStyle(color: colors.onPrimary),
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
              // Cor alterada para onBackground
              style: TextStyle(color: colors.onBackground),
            ),
          );
        }

        final entity = controller.process.value!;
        final dateFormatted = this._formatCreatedAt(entity.createdAt);

        // O SharedBackground envolve todo o layout dinâmico
        return SharedBackground(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                child: Padding(
                  // Essa margem de 32px de cada lado é o que dá o respiro do Figma
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // 1. Cabeçalho Superior (agora vai esticar junto)
                      this._buildProcessStatusBar(
                        context,
                        entity,
                        dateFormatted,
                        isDesktop,
                      ),
                      const SizedBox(height: 24),
                      // 2. Menu e Conteúdo (sem ConstrainedBox)
                      isDesktop
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
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
class ProcessDetailCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final Color? backgroundColor;

  const ProcessDetailCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}