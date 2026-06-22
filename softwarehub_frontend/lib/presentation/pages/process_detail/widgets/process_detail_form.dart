part of '../process_detail_page.dart';

extension _ProcessDetailPageForm on _ProcessDetailPageState {
  Widget _buildDynamicForm(BuildContext context, ProcessResponseEntity entity) {
    final fieldsStructure = entity.ipType.formStructure.fields;

    if (fieldsStructure.isEmpty) {
      return this._buildEmptyState(
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

        return this._buildFieldItem(
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

    return this._buildSimpleCard(
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
