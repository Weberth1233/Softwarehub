import 'package:flutter/material.dart';

class ApplicationFieldEmptyState extends StatelessWidget {
  const ApplicationFieldEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withOpacity(0.09),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_tree_outlined,
            color: colors.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Nenhum campo de aplicação encontrado.",
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
}