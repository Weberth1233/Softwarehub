import 'package:flutter/material.dart';

class ProcessPageHeader extends StatelessWidget {
  final bool isEditMode;

  const ProcessPageHeader({
    super.key,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditMode ? "Editar seu processo" : "Cadastre seu processo",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.black87,
            letterSpacing: -0.1,
            fontSize: 35,
          ),
        ),
        Text(
          isEditMode
              ? "Insira as informações necessárias para atualizar seu processo no sistema."
              : "Insira as informações necessárias para cadastrar seu processo no sistema.",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}