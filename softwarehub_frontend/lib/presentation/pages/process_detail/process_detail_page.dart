import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/app_routes.dart';
import '../../../domain/entities/process/process_response_entity.dart';
import '../../../domain/entities/user/user_educational_institution_link_entity.dart';
import '../../shared/utils/app_toast.dart';
import 'controllers/process_detail_controller.dart';

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
        final dateFormatted = _formatCreatedAt(entity.createdAt);

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DiagonalLinesPainter(
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
                        child: _buildProcessStatusBar(
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
                                ? _buildWideMasterDetail(
                                    context,
                                    entity,
                                    controller,
                                    constraints.maxWidth,
                                  )
                                : _buildNarrowMasterDetail(
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

  Widget _buildWideMasterDetail(
    BuildContext context,
    ProcessResponseEntity entity,
    ProcessDetailController controller,
    double availableWidth,
  ) {
    final colors = Theme.of(context).colorScheme;
    const maxLayoutWidth = 1500.0;
    final totalWidth = availableWidth < maxLayoutWidth
        ? availableWidth
        : maxLayoutWidth;
    const menuWidth = 300.0;
    const gap = 24.0;
    final panelWidth = totalWidth - menuWidth - gap;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: menuWidth,
          child: _buildDesktopSideMenu(context, entity, controller),
        ),
        const SizedBox(width: gap),
        SizedBox(
          width: panelWidth,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.onSecondary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: _buildSelectedContent(context, entity),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowMasterDetail(
    BuildContext context,
    ProcessResponseEntity entity,
    ProcessDetailController controller,
  ) {
    void showApproveDialog(BuildContext context, ProcessResponseEntity entity) {
      Get.defaultDialog(
        title: "Confirmar finalização do processo",
        middleText:
            "Tem certeza que deseja finalizar o processo \"${entity.title}\"?",
        textConfirm: "Confirmar",
        textCancel: "Cancelar",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm: _isApproving
            ? null
            : () async {
                Get.back();

                await _runAction(
                  setLoading: (value) => _isApproving = value,
                  action: () async {
                    await controller.uploadStatusProcess(
                      entity.id,
                      "FINALIZADO",
                    );
                  },
                );
              },
      );
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.onSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tipo da Propriedade Intelectual",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entity.ipType.name,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.tertiary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMobileMenuItem(
                context,
                index: 0,
                icon: Icons.person_outline,
                title: "Solicitante",
              ),
              _buildMobileMenuItem(
                context,
                index: 1,
                icon: Icons.group_outlined,
                title: "Membros",
              ),
              _buildMobileMenuItem(
                context,
                index: 2,
                icon: Icons.group_outlined,
                title: "Membros Externos",
              ),
              _buildMobileMenuItem(
                context,
                index: 3,
                icon: Icons.list_alt_outlined,
                title: "Dados",
              ),
              _buildMobileMenuItem(
                context,
                index: 4,
                icon: Icons.attach_file_outlined,
                title: "Anexos",
              ),
              _buildMobileMenuItem(
                context,
                index: 5,
                icon: Icons.approval,
                title: "Correção",
              ),
              _buildMobileMenuItem(
                context,
                index: 6,
                icon: Icons.category_outlined,
                title: "Nice",
              ),
              _buildMobileMenuItem(
                context,
                index: 7,
                icon: Icons.pie_chart_outline,
                title: "Cotas",
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.onSecondary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _buildSelectedContent(context, entity),
        ),

        if (controller.isAdmin) ...[
          const SizedBox(height: 24),
          Text(
            "Ações Administrativas",
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: entity.status == "FINALIZADO" || _isApproving
                      ? null
                      : () {
                          showApproveDialog(context, entity);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isApproving ? "Aprovando..." : "Aprovar",
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isClassifying
                      ? null
                      : () async {
                          final result = await Get.toNamed(
                            AppRoutes.processApplicationFieldById(entity.id),
                          );

                          if (result is List<int>) {
                            await _runAction(
                              setLoading: (value) => _isClassifying = value,
                              action: () async {
                                await controller.classifyProcess(
                                  entity.id,
                                  result,
                                );
                              },
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    child: Text(
                      _isClassifying
                          ? "Classificando..."
                          : "Classificação de Nice",
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Get.toNamed(
                      AppRoutes.processJustificationById(entity.id),
                      arguments: {'processId': entity.id},
                    );

                    if (result != null && result is int) {
                      print("Atualizando o processo");
                      await controller.fetchProcess(result);
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Devolver",
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDesktopSideMenu(
    BuildContext context,
    ProcessResponseEntity entity,
    ProcessDetailController controller,
  ) {
    void showApproveDialog(BuildContext context, ProcessResponseEntity entity) {
      Get.defaultDialog(
        title: "Confirmar finalização do processo",
        middleText:
            "Tem certeza que deseja finalizar o processo \"${entity.title}\"?",
        textConfirm: "Confirmar",
        textCancel: "Cancelar",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm: _isApproving
            ? null
            : () async {
                Get.back();

                await _runAction(
                  setLoading: (value) => _isApproving = value,
                  action: () async {
                    await controller.uploadStatusProcess(
                      entity.id,
                      "FINALIZADO",
                    );
                  },
                );
              },
      );
    }

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Seções",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: colors.tertiary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tipo da Propriedade Intelectual",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entity.ipType.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDesktopMenuItem(
            context,
            index: 0,
            icon: Icons.person_outline,
            title: "SOLICITANTE",
            subtitle: "Quem criou o processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 1,
            icon: Icons.group_outlined,
            title: "MEMBROS",
            subtitle: "Vinculados ao processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 2,
            icon: Icons.group_outlined,
            title: "MEMBROS EXTERNOS",
            subtitle: "Vinculados externos ao processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 3,
            icon: Icons.list_alt_outlined,
            title: "DADOS DO PROCESSO",
            subtitle: "Formulário preenchido",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 4,
            icon: Icons.attach_file_outlined,
            title: "ANEXOS",
            subtitle: "Arquivos do processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 5,
            icon: Icons.approval,
            title: "CORREÇÃO",
            subtitle: "Correções do processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 6,
            icon: Icons.category_outlined,
            title: "CLASSIFICAÇÃO DE NICE",
            subtitle: "Classe vinculada ao processo",
          ),
          const SizedBox(height: 10),
          _buildDesktopMenuItem(
            context,
            index: 7,
            icon: Icons.pie_chart_outline,
            title: "DISTRIBUIÇÃO DE COTAS",
            subtitle: "Percentuais de royalties",
          ),

          if (controller.isAdmin) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              "Ações Administrativas",
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 19,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _isClassifying
                      ? null
                      : () async {
                          final result = await Get.toNamed(
                            AppRoutes.processApplicationFieldById(entity.id),
                          );

                          if (result is List<int>) {
                            await _runAction(
                              setLoading: (value) => _isClassifying = value,
                              action: () async {
                                await controller.classifyProcess(
                                  entity.id,
                                  result,
                                );
                              },
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 2,
                    ),
                    child: Text(
                      _isClassifying
                          ? "Classificando..."
                          : "Classificação de Nice",
                      style: TextStyle(
                        color: colors.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: entity.status == "FINALIZADO" || _isApproving
                      ? null
                      : () {
                          showApproveDialog(context, entity);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    _isApproving ? "Aprovando..." : "Aprovar",
                    style: TextStyle(color: colors.onSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Get.toNamed(
                      AppRoutes.processJustificationById(entity.id),
                      arguments: {'processId': entity.id},
                    );

                    if (result != null && result is int) {
                      print("Atualizando o processo");
                      await controller.fetchProcess(result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    "Devolver",
                    style: TextStyle(color: colors.onSecondary),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopMenuItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = _selectedIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.10) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colors.primary.withOpacity(0.35)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? colors.primary : colors.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colors.tertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: colors.secondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.secondary),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.onSecondary
                : colors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : colors.onSecondary.withOpacity(0.2),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? colors.primary : colors.onSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? colors.primary : colors.onSecondary,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    String title;
    String subtitle;
    Widget content;

    switch (_selectedIndex) {
      case 0:
        title = "SOLICITANTE";
        subtitle = "Dados de quem criou o processo.";
        content = _buildCreatorCard(context, entity);
        break;
      case 1:
        title = "MEMBROS";
        subtitle = "Pessoas vinculadas ao processo.";
        content = _buildMembersList(context, entity);
        break;
      case 2:
        title = "MEMBROS EXTERNOS";
        subtitle = "Pessoas externas vinculadas ao processo.";
        content = _buildExternalMembersList(context, entity);
        break;
      case 3:
        title = "DADOS DO PROCESSO";
        subtitle = "Informações preenchidas no formulário.";
        content = _buildDynamicForm(context, entity);
        break;
      case 4:
        title = "ANEXOS";
        subtitle =
            "Arquivos relacionados ao processo. Clique no processo para enviá-lo assinado.";
        content = _buildAttachmentsList(context, entity);
        break;
      case 5:
        title = "CORREÇÕES / JUSTIFICATIVAS";
        subtitle = "Correções e observações.";
        content = _buildFixesList(context, entity);
        break;
      case 6:
        title = "CLASSIFICAÇÃO DE NICE";
        subtitle = "Classificação vinculada ao processo.";
        content = _buildApplicationFieldsCard(context, entity);
        break;
      case 7:
        title = "DISTRIBUIÇÃO DE COTAS";
        subtitle = "Percentuais de royalties vinculados ao processo.";
        content = _buildRoyaltyDistributionsList(context, entity);
        break;
      default:
        title = "";
        subtitle = "";
        content = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colors.tertiary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.secondary),
        ),
        const SizedBox(height: 18),
        content,
      ],
    );
  }

  Widget _buildMembersList(BuildContext context, ProcessResponseEntity entity) {
    if (entity.authors.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.group_outlined,
        message: "Nenhum membro interno vinculado ao processo.",
        //process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.authors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final author = entity.authors[index];

        return _buildPersonRowCard(
          context,
          name: author.fullName,
          email: author.email,
          birthDate: author.birthDate,
          phoneNumber: author.phoneNumber,
          profession: author.profession,
          trailingIcon: Icons.person_outline,
          userEducationalInstitutionLinks:
              entity.creator.userEducationalInstitutionLinks,
        );
      },
    );
  }

  Widget _buildExternalMembersList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    if (entity.externalAuthors.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.group_outlined,
        message: "Nenhum membro externo vinculado ao processo.",
        // process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.externalAuthors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final author = entity.externalAuthors[index];

        return _buildPersonRowCard(
          context,
          name: author.fullName,
          email: author.email,
          birthDate: "",
          phoneNumber: "",
          profession: "",
          trailingIcon: Icons.person_outline,
          userEducationalInstitutionLinks: [],
        );
      },
    );
  }

  Widget _buildRoyaltyDistributionsList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;

    if (entity.royaltyDistributions.isEmpty) {
      return _buildEmptyRoyaltDistributionState(
        context,
        icon: Icons.pie_chart_outline,
        message: "Nenhuma distribuição de cotas vinculada a este processo.",
        process: entity,
      );
    }

    final activeDistributions = entity.royaltyDistributions
        .where((distribution) => distribution.status == "ACTIVE")
        .toList();

    final distributionsToShow = activeDistributions.isNotEmpty
        ? activeDistributions
        : entity.royaltyDistributions;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: distributionsToShow.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final distribution = distributionsToShow[index];

        final totalPercentage = distribution.shares.fold<double>(
          0,
          (previousValue, share) => previousValue + share.percentage,
        );

        final isActive = distribution.status == "ACTIVE";

        return _buildSimpleCard(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.pie_chart_outline, color: colors.primary),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Distribuição versão ${distribution.version}",
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  TextButton.icon(
                    onPressed: () async {
                      final result = await Get.toNamed(
                        AppRoutes.processRoyaltyDistributionById(entity.id),
                        arguments: {
                          "distributionId": distribution.id,
                          'openedFromProcessFlow': false,
                        },
                      );

                      if (result != null && result is int) {
                        print("Atualizando o processo");
                        await controller.fetchProcess(result);
                      }
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: colors.primary,
                    ),
                    label: Text(
                      "Editar",
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colors.primary.withOpacity(0.08),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (isActive ? Colors.green : Colors.grey)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isActive ? "Ativa" : "Inativa",
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Total distribuído: ${totalPercentage.toStringAsFixed(2)}%",
                style: TextStyle(
                  color: colors.tertiary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              if (distribution.shares.isEmpty)
                _buildEmptyState(
                  context,
                  icon: Icons.percent_outlined,
                  message: "Nenhuma cota encontrada nesta distribuição.",
                  //process: entity,
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: distribution.shares.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, shareIndex) {
                    final share = distribution.shares[shareIndex];

                    final title = _getRoyaltyShareTitle(share);
                    final subtitle = _getRoyaltyShareSubtitle(share);
                    final icon = _getRoyaltyShareIcon(share.type);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: colors.primary,
                            child: Icon(
                              icon,
                              color: colors.onSecondary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: colors.tertiary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: colors.secondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              "${share.percentage.toStringAsFixed(2)}%",
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _getRoyaltyShareTitle(dynamic share) {
    if (share.type == "UNIVERSITY") {
      final institutionName = share.educationalInstitutionName;

      if (institutionName != null &&
          institutionName.toString().trim().isNotEmpty) {
        return institutionName.toString();
      }

      return "Instituição não informada";
    }

    final userName = share.userName;

    if (userName != null && userName.toString().trim().isNotEmpty) {
      return userName.toString();
    }

    return "Usuário não informado";
  }

  String _getRoyaltyShareSubtitle(dynamic share) {
    switch (share.type) {
      case "UNIVERSITY":
        return "Instituição de ensino";
      case "CREATOR":
        return "Criador";
      case "MEMBER":
        return "Membro";
      default:
        return share.type.toString();
    }
  }

  IconData _getRoyaltyShareIcon(String type) {
    switch (type) {
      case "UNIVERSITY":
        return Icons.account_balance_outlined;
      case "CREATOR":
        return Icons.star_border;
      case "MEMBER":
        return Icons.person_outline;
      default:
        return Icons.percent_outlined;
    }
  }

  Widget _buildApplicationFieldsCard(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;
    final applicationFields = entity.applicationFields;

    return _buildSimpleCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category_outlined, color: colors.primary),
              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  "Campos de Aplicação",
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),

              if (applicationFields.isNotEmpty)
                TextButton.icon(
                  onPressed: () async {
                    final result = await Get.toNamed(
                      AppRoutes.processApplicationFieldById(entity.id),
                      arguments: {
                        'isEditMode': true,
                        'selectedApplicationFieldIds': applicationFields
                            .map((field) => field.id)
                            .toList(),
                      },
                    );

                    if (result != null && result is List) {
                      final selectedIds = result
                          .map((item) => int.parse(item.toString()))
                          .toList();

                      print("Campos selecionados na edição: $selectedIds");

                      // Aqui você chama o método que atualiza no backend.
                      // Exemplo:
                      //
                      // await controller.updateApplicationFieldsProcess(
                      //   processId: entity.id,
                      //   applicationFieldIds: selectedIds,
                      // );
                      //
                      // Depois atualiza os detalhes do processo:
                      // await controller.fetchProcess(entity.id);
                    }
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: colors.primary,
                  ),
                  label: Text(
                    "Editar",
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: colors.primary.withOpacity(0.08),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          if (applicationFields.isEmpty)
            Text(
              "Nenhum campo de aplicação vinculado ao processo.",
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            )
          else
            Column(
              children: applicationFields.map((applicationField) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.outline.withOpacity(0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        applicationField.applicationAreaName,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Código",
                        style: TextStyle(
                          color: colors.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        applicationField.code,
                        style: TextStyle(
                          color: colors.tertiary,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Nome",
                        style: TextStyle(
                          color: colors.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        applicationField.name,
                        style: TextStyle(
                          color: colors.tertiary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Descrição",
                        style: TextStyle(
                          color: colors.secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        applicationField.description.isNotEmpty
                            ? applicationField.description
                            : "Sem descrição informada.",
                        style: TextStyle(color: colors.tertiary, height: 1.4),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildFixesList(BuildContext context, ProcessResponseEntity entity) {
    final controller = this.controller;

    if (entity.justifications.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.sticky_note_2_outlined,
        message: "Não há correções ou justificativas.",
        // process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.justifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final justification = entity.justifications[index];

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.amber.shade800,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Observação #${justification.id}",
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            justification.reason,
                            style: const TextStyle(
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.isAdmin)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 12,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (justification.attachment != null) {
                                await controller.getAttachmentFile(
                                  justification.attachment!.id,
                                );

                                final bytes = controller.attachmentBytes.value;

                                if (bytes == null || bytes.isEmpty) {
                                  AppToast.error(
                                    "Não foi possível carregar o arquivo.",
                                  );
                                  return;
                                }

                                if (controller.isAttachmentImage) {
                                  Get.dialog(
                                    Dialog(
                                      insetPadding: const EdgeInsets.all(24),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 800,
                                          maxHeight: 700,
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Image.memory(
                                          bytes,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (controller.isAttachmentPdf) {
                                  controller.openPdfInNewTab();
                                } else {
                                  AppToast.error(
                                    "Tipo de arquivo não suportado para visualização.",
                                  );
                                }
                              } else {
                                AppToast.warning(
                                  "Não há documento disponível para essa justificativa!.",
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.document_scanner,
                              color: Colors.blueGrey,
                              size: 22,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            onPressed: () async {
                              final result = await Get.toNamed(
                                AppRoutes.processJustificationById(entity.id),
                                arguments: {
                                  'processId': entity.id,
                                  'justificationId': justification.id,
                                  'reason': justification.reason,
                                  'attachmentFileName':
                                      justification.attachment?.fileName,
                                },
                              );

                              if (result != null && result is int) {
                                print("Atualizando o processo");
                                await controller.fetchProcess(result);
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.green,
                              size: 22,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),

                          IconButton(
                            onPressed: _isDeletingJustification
                                ? null
                                : () {
                                    Get.defaultDialog(
                                      title: "Excluir justificativa",
                                      middleText:
                                          "Tem certeza que deseja excluir esta justificativa?",
                                      textConfirm: "Excluir",
                                      textCancel: "Cancelar",
                                      confirmTextColor: Colors.white,
                                      buttonColor: Colors.red,
                                      onConfirm: () async {
                                        Get.back();

                                        await _runAction(
                                          setLoading: (value) =>
                                              _isDeletingJustification = value,
                                          action: () async {
                                            await controller
                                                .deleteJustificationProcess(
                                                  justification.id,
                                                );
                                          },
                                        );
                                      },
                                    );
                                  },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentsList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;

    if (entity.attachments.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.attach_file_outlined,
        message: "Nenhum anexo vinculado a este processo.",
        // process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.attachments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final attachment = entity.attachments[index];
        final isSigned = attachment.signedFilePath.isNotEmpty;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Get.toNamed(AppRoutes.processAttachmentsById(entity.id)),
          child: _buildSimpleCard(
            context,
            child: Row(
              children: [
                Icon(
                  isSigned ? Icons.check_circle : Icons.description_outlined,
                  color: isSigned ? Colors.green : colors.secondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: colors.tertiary,
                        ),
                      ),
                      Text(
                        attachment.status,
                        style: TextStyle(color: colors.secondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isSigned ? Colors.green : Colors.orange)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isSigned ? "Assinado" : "Pendente",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: isSigned ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProcessStatusBar(
    BuildContext context,
    ProcessResponseEntity entity,
    String date,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final title = entity.title.isNotEmpty ? entity.title : entity.ipType.name;
    final statusUI = _statusUi(context, entity.status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 25 : 16,
        vertical: isDesktop ? 25 : 16,
      ),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(
              color: statusUI.color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: isDesktop ? 25 : 18,
                    fontWeight: FontWeight.w900,
                    color: colors.tertiary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID #${entity.id} • $date",
                  style: TextStyle(fontSize: 13, color: colors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 15 : 10,
              vertical: isDesktop ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: statusUI.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusUI.icon, size: 14, color: statusUI.color),
                if (isDesktop) const SizedBox(width: 6),
                if (isDesktop)
                  Text(
                    statusUI.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: statusUI.color,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusUi _statusUi(BuildContext context, String status) {
    final colors = Theme.of(context).colorScheme;

    Color color;
    IconData icon;
    String label = status.replaceAll('_', ' ').toUpperCase();

    switch (status) {
      case 'EM_ANDAMENTO':
        color = Colors.orange;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'FINALIZADO':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'CORRECAO':
        color = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      default:
        color = colors.secondary;
        icon = Icons.info_outline;
    }

    return _StatusUi(color: color, icon: icon, label: label);
  }

  Widget _buildSimpleCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.09)),
      ),
      child: child,
    );
  }

  Widget _buildEmptyRoyaltDistributionState(
    BuildContext context, {
    required IconData icon,
    required String message,
    required ProcessResponseEntity process,
  }) {
    final colors = Theme.of(context).colorScheme;

    return _buildSimpleCard(
      context,
      child: Row(
        children: [
          Icon(icon, color: colors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final result = await Get.toNamed(
                AppRoutes.processRoyaltyDistributionById(process.id),
                arguments: {'openedFromProcessFlow': false},
              );
              if (result != null && result is int) {
                print("Atualizando o processo");
                await controller.fetchProcess(result);
              }
            },
            child: Text(
              "Distribuir cotas ao processo",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String message,
  }) {
    final colors = Theme.of(context).colorScheme;

    return _buildSimpleCard(
      context,
      child: Row(
        children: [
          Icon(icon, color: colors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool compact = false,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: colors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.trim().isNotEmpty ? value : "Não informado",
                  style: TextStyle(
                    color: colors.tertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorCard(BuildContext context, ProcessResponseEntity entity) {
    return _buildPersonRowCard(
      context,
      name: entity.creator.fullName,
      email: entity.creator.email,
      birthDate: entity.creator.birthDate,
      phoneNumber: entity.creator.phoneNumber,
      profession: entity.creator.profession,
      userEducationalInstitutionLinks:
          entity.creator.userEducationalInstitutionLinks,
      trailingIcon: Icons.star_border,
    );
  }

  String _formatPhone(String phone) {
    final numbers = phone.replaceAll(RegExp(r'\D'), '');

    if (numbers.length == 11) {
      return '(${numbers.substring(0, 2)}) '
          '${numbers.substring(2, 7)}-'
          '${numbers.substring(7)}';
    }

    if (numbers.length == 10) {
      return '(${numbers.substring(0, 2)}) '
          '${numbers.substring(2, 6)}-'
          '${numbers.substring(6)}';
    }

    return phone;
  }

  String _formatBirthDate(String date) {
    try {
      if (date.trim().isEmpty) return "Data de nascimento não informada";

      final parsedDate = DateTime.tryParse(date);

      if (parsedDate == null) return date;

      return '${parsedDate.day.toString().padLeft(2, '0')}/'
          '${parsedDate.month.toString().padLeft(2, '0')}/'
          '${parsedDate.year}';
    } catch (_) {
      return date;
    }
  }

  String _formatCreatedAt(dynamic date) {
    try {
      if (date == null) return "Data não informada";

      final parsedDate = date is DateTime
          ? date
          : DateTime.tryParse(date.toString());

      if (parsedDate == null) return "Data inválida";

      return DateFormat("d 'de' MMM 'de' y", "pt_BR").format(parsedDate);
    } catch (_) {
      return "Data inválida";
    }
  }

  Widget _buildPersonRowCard(
    BuildContext context, {
    required String name,
    required String email,
    required String phoneNumber,
    required String birthDate,
    required String profession,
    required List<UserEducationalInstitutionLinkEntity>
    userEducationalInstitutionLinks,
    required IconData trailingIcon,
  }) {
    final colors = Theme.of(context).colorScheme;

    final displayName = name.trim().isNotEmpty
        ? name.trim()
        : "Nome não informado";

    final firstLetter = displayName != "Nome não informado"
        ? displayName.substring(0, 1).toUpperCase()
        : "?";

    return _buildSimpleCard(
      context,
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: colors.primary,
          child: Text(
            firstLetter,
            style: TextStyle(
              color: colors.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(fontWeight: FontWeight.w800, color: colors.tertiary),
        ),
        subtitle: Text(
          email.trim().isNotEmpty ? email : "E-mail não informado",
          style: TextStyle(color: colors.secondary, fontSize: 13),
        ),
        trailing: Icon(trailingIcon, color: colors.secondary),
        children: [
          const SizedBox(height: 8),

          _buildInfoRow(
            context,
            icon: Icons.email_outlined,
            label: "E-mail",
            value: email.trim().isNotEmpty ? email : "E-mail não informado",
          ),

          _buildInfoRow(
            context,
            icon: Icons.phone_outlined,
            label: "Telefone",
            value: phoneNumber.trim().isNotEmpty
                ? _formatPhone(phoneNumber)
                : "Telefone não informado",
          ),

          _buildInfoRow(
            context,
            icon: Icons.cake_outlined,
            label: "Data de nascimento",
            value: birthDate.trim().isNotEmpty
                ? _formatBirthDate(birthDate)
                : "Data de nascimento não informada",
          ),

          _buildInfoRow(
            context,
            icon: Icons.work_outline,
            label: "Profissão",
            value: profession.trim().isNotEmpty
                ? profession
                : "Profissão não informada",
          ),

          if (userEducationalInstitutionLinks.isNotEmpty) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.school_outlined, size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  "Instituições de ensino",
                  style: TextStyle(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userEducationalInstitutionLinks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final result = userEducationalInstitutionLinks[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.outline.withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        context,
                        icon: Icons.account_balance_outlined,
                        label: "Instituição",
                        value: result.educationalInstitution.name,
                        compact: true,
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        context,
                        icon: Icons.badge_outlined,
                        label: "Vínculo",
                        value: result.typesLink.name,
                        compact: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDynamicForm(BuildContext context, ProcessResponseEntity entity) {
    final fieldsStructure = entity.ipType.formStructure.fields;

    if (fieldsStructure.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.list_alt_outlined,
        message: "Nenhum campo de formulário encontrado.",
        //process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: fieldsStructure.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final fieldDef = fieldsStructure[index];
        final value = entity.formData[fieldDef.key];

        return _buildFieldItem(
          context,
          label: fieldDef.name,
          value: value != null && value.toString().trim().isNotEmpty
              ? value.toString() == 'YES'
                    ? "SIM"
                    : value.toString() == "NO"
                    ? "NÃO"
                    : value.toString()
              : 'Não informado',
          type: fieldDef.type,
        );
      },
    );
  }

  Widget _buildFieldItem(
    BuildContext context, {
    required String label,
    required String value,
    required String type,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isTextArea = type == 'textArea';

    return _buildSimpleCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isTextArea ? Icons.description_outlined : Icons.short_text,
                size: 16,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: colors.tertiary,
              height: isTextArea ? 1.5 : 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusUi {
  final Color color;
  final IconData icon;
  final String label;

  _StatusUi({required this.color, required this.icon, required this.label});
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
