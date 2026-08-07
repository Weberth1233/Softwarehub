import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HeaderCard extends StatelessWidget {
  final HomeController processController;
  
  const HeaderCard({super.key, required this.processController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Painel de processos",
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Sistema de gestão de propriedade intelectual",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 17,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.toNamed(AppRoutes.process);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 22),
              SizedBox(width: 6),
              Text(
                "NOVO PROCESSO",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: "Recarregar dados da tela",
          onPressed: () async{
            await processController.processStatusCount();
            await processController.fetchProcesses();
          },
          icon: Icon(Icons.replay_outlined),
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}
