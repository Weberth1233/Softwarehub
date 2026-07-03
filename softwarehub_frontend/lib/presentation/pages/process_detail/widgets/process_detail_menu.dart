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

    // A variável cardDecoration foi removida daqui,
    // pois o ProcessDetailCard já cuida de todo o visual!

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // CARD DE SEÇÕES
        ProcessDetailCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 16, top: 4),
                child: Text(
                  "Seções",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colors.tertiary,
                  ),
                ),
              ),
              _buildDesktopMenuItem(
                context,
                index: 0,
                icon: Icons.person_outline,
                title: "SOLICITANTE",
                subtitle: "Quem criou o processo",
              ),
              const SizedBox(height: 4),
              _buildDesktopMenuItem(
                context,
                index: 1,
                icon: Icons.group_outlined,
                title: "MEMBROS",
                subtitle: "Equipe interna",
              ),
              const SizedBox(height: 4),
              _buildDesktopMenuItem(
                context,
                index: 2,
                icon: Icons.group_add_outlined,
                title: "MEMBROS EXTERNOS",
                subtitle: "Convidados e parceiros",
              ),
              const SizedBox(height: 4),
              _buildDesktopMenuItem(
                context,
                index: 3,
                icon: Icons.description_outlined,
                title: "DADOS DO PROCESSO",
                subtitle: "Informações gerais",
              ),
              const SizedBox(height: 4),
              _buildDesktopMenuItem(
                context,
                index: 4,
                icon: Icons.attach_file_outlined,
                title: "ANEXOS",
                subtitle: "Arquivos e documentos",
              ),
              const SizedBox(height: 4),
              _buildDesktopMenuItem(
                context,
                index: 5,
                icon: Icons.edit_outlined,
                title: "CORREÇÃO",
                subtitle: "Ajustes necessários",
              ),
              const SizedBox(height: 4),
              _buildDesktopMenuItem(
                context,
                index: 6,
                icon: Icons.sell_outlined,
                title: "CLASSIFICAÇÃO DE NICE",
                subtitle: "Classes e produtos",
              ),
              const SizedBox(height: 4),
              _buildDesktopMenuItem(
                context,
                index: 7,
                icon: Icons.pie_chart_outline,
                title: "DISTRIBUIÇÃO DE COTAS",
                subtitle: "Percentuais de royalties",
              ),
            ],
          ),
        ),

        // CARD DE AÇÕES ADMINISTRATIVAS
        if (controller.isAdmin) ...[
          const SizedBox(height: 16),
          ProcessDetailCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Ações Administrativas",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.tertiary,
                    fontSize: 19,
                  ),
                ),
                const SizedBox(height: 5),
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
                    backgroundColor: const Color(0XFF004093),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 2,
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
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: entity.status == "FINALIZADO" || _isApproving
                      ? null
                      : () {
                    showApproveDialog(context, entity);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0CCA52),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    _isApproving ? "Aprovando..." : "Aprovar",
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Get.toNamed(
                      AppRoutes.processJustificationById(entity.id),
                      arguments: {'processId': entity.id},
                    );

                    if (result != null && result is int) {
                      await controller.fetchProcess(result);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Devolver",
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
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
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F4F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? colors.primary : colors.secondary,
              ),
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
                      color: isSelected ? colors.tertiary : colors.secondary.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.secondary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isSelected ? colors.primary : Colors.transparent,
            ),
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