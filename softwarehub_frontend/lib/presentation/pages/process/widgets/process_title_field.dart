import 'package:flutter/material.dart';

import '../../../shared/widgets/custom_text_field.dart';

class ProcessTitleField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const ProcessTitleField({
    super.key,
    required this.controller,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            "Título da API:",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: errorText != null ? Colors.red.shade700 : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomTextField(
            controller: controller,
            label: "",
            hintText: "Ex: Registro de Patente de Software",
            errorText: errorText,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }
}