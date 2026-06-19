import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/app_routes.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.register),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primary,
              side: BorderSide(color: colors.primary.withOpacity(0.55)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
            label: const Text(
              "Cadastre-se",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Get.toNamed(AppRoutes.forgotPassword);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF6D00),
              side: const BorderSide(color: Color(0xFFFF6D00)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
            ),
            icon: const Icon(Icons.key_outlined, size: 20),
            label: const Text(
              "Recuperar Senha",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
