part of '../process_detail_page.dart';

extension _ProcessDetailPageLayout on _ProcessDetailPageState {
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
          child: this._buildDesktopSideMenu(context, entity, controller),
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
            child: this._buildSelectedContent(context, entity),
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

                await this._runAction(
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
              this._buildMobileMenuItem(
                context,
                index: 0,
                icon: Icons.person_outline,
                title: "Solicitante",
              ),
              this._buildMobileMenuItem(
                context,
                index: 1,
                icon: Icons.group_outlined,
                title: "Membros",
              ),
              this._buildMobileMenuItem(
                context,
                index: 2,
                icon: Icons.group_outlined,
                title: "Membros Externos",
              ),
              this._buildMobileMenuItem(
                context,
                index: 3,
                icon: Icons.list_alt_outlined,
                title: "Dados",
              ),
              this._buildMobileMenuItem(
                context,
                index: 4,
                icon: Icons.attach_file_outlined,
                title: "Anexos",
              ),
              this._buildMobileMenuItem(
                context,
                index: 5,
                icon: Icons.approval,
                title: "Correção",
              ),
              this._buildMobileMenuItem(
                context,
                index: 6,
                icon: Icons.category_outlined,
                title: "Nice",
              ),
              this._buildMobileMenuItem(
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
          child: this._buildSelectedContent(context, entity),
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
                            await this._runAction(
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
}
