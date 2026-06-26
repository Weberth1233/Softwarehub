part of '../process_detail_page.dart';

extension _ProcessDetailPageMenu on _ProcessDetailPageState {
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
          this._buildDesktopMenuItem(
            context,
            index: 0,
            icon: Icons.person_outline,
            title: "SOLICITANTE",
            subtitle: "Quem criou o processo",
          ),
          const SizedBox(height: 10),
          this._buildDesktopMenuItem(
            context,
            index: 1,
            icon: Icons.group_outlined,
            title: "MEMBROS",
            subtitle: "Vinculados ao processo",
          ),
          const SizedBox(height: 10),
          this._buildDesktopMenuItem(
            context,
            index: 2,
            icon: Icons.group_outlined,
            title: "MEMBROS EXTERNOS",
            subtitle: "Vinculados externos ao processo",
          ),
          const SizedBox(height: 10),
          this._buildDesktopMenuItem(
            context,
            index: 3,
            icon: Icons.list_alt_outlined,
            title: "DADOS DO PROCESSO",
            subtitle: "Formulário preenchido",
          ),
          const SizedBox(height: 10),
          this._buildDesktopMenuItem(
            context,
            index: 4,
            icon: Icons.attach_file_outlined,
            title: "ANEXOS",
            subtitle: "Arquivos do processo",
          ),
          const SizedBox(height: 10),
          this._buildDesktopMenuItem(
            context,
            index: 5,
            icon: Icons.approval,
            title: "CORREÇÃO",
            subtitle: "Correções do processo",
          ),
          const SizedBox(height: 10),
          this._buildDesktopMenuItem(
            context,
            index: 6,
            icon: Icons.category_outlined,
            title: "CLASSIFICAÇÃO DE NICE",
            subtitle: "Classe vinculada ao processo",
          ),
          const SizedBox(height: 10),
          this._buildDesktopMenuItem(
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

                          if (result != null && result is List) {
                            final selectedIds = result
                                .map((item) => int.tryParse(item.toString()))
                                .whereType<int>()
                                .toList();

                            print(
                              "Campos selecionados na edição: $selectedIds",
                            );

                            if (selectedIds.isEmpty) {
                              AppToast.error(
                                "Selecione pelo menos um campo de aplicação.",
                              );
                              return;
                            }

                            await this._runAction(
                              setLoading: (value) => _isClassifying = value,
                              action: () async {
                                await controller.classifyProcess(
                                  entity.id,
                                  selectedIds,
                                  isEdit: true,
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
}
