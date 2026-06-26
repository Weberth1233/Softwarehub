part of '../process_detail_page.dart';

extension _ProcessDetailPageNice on _ProcessDetailPageState {
  Widget _buildApplicationFieldsCard(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;
    final applicationFields = entity.applicationFields;

    return this._buildSimpleCard(
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

              if (controller.isAdmin && applicationFields.isNotEmpty)
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
                          .map((item) => int.tryParse(item.toString()))
                          .whereType<int>()
                          .toList();

                      print("Campos selecionados na edição: $selectedIds");

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
}
