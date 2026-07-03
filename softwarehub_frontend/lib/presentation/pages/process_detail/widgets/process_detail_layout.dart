part of '../process_detail_page.dart';

extension _ProcessDetailPageLayout on _ProcessDetailPageState {

  // ===========================================================================
  // LAYOUT DESKTOP (Telas Grandes)
  // ===========================================================================
  Widget _buildWideMasterDetail(
      BuildContext context,
      ProcessResponseEntity entity,
      ProcessDetailController controller,
      double availableWidth, // Mantemos a assinatura para não quebrar a page principal
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 400,
          child: this._buildDesktopSideMenu(context, entity, controller),
        ),

        const SizedBox(width: 24),

        // Utilizando o componente padronizado para o card de conteúdo
        Expanded(
          child: ProcessDetailCard(
            padding: const EdgeInsets.all(24),
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
        // Utilizando o componente para o card do Tipo de Propriedade no Mobile
        ProcessDetailCard(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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

        // Área de Conteúdo Principal (Mobile) refatorada com o componente
        ProcessDetailCard(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: this._buildSelectedContent(context, entity),
        ),

        // Ações Administrativas (No final da página no Mobile)
        if (controller.isAdmin) ...[
          const SizedBox(height: 24),
          Text(
            "Ações Administrativas",
            style: theme.textTheme.titleMedium?.copyWith(
              color: colors.tertiary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
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
                  backgroundColor: const Color(0xFF22C55E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
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
        ],
      ],
    );
  }
}