import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class StatusLabel extends StatelessWidget {
  final HomeController processController;

  const StatusLabel({super.key, required this.processController});

  Color getStatusColor(String status) {
    switch (status) {
      case "PENDENTE_DISTRIBUICAO_COTAS":
        return const Color.fromARGB(255, 228, 206, 11);

      case "COTAS_DISTRIBUIDAS":
        return Colors.blue;

      case "CORRECAO":
        return Colors.red;

      case "CORRIGIDO":
        return Colors.orange;

      case "CLASSIFICADO":
        return Colors.purple;

      case "FINALIZADO":
        return const Color.fromARGB(255, 54, 149, 57);

      case "INATIVO":
        return Colors.grey;

      case "PENDENTE_DOCUMENTACAO":
        return Colors.black;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topLeft,
      child: Obx(() {
        if (processController.isLoadingProcessCount.value) {
          return const CircularProgressIndicator();
        }
        if (processController.processesStatus.isEmpty) {
          return const Text("Nenhum dado encontrado");
        }
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: processController.processesStatus.map((item) {
            final color = getStatusColor(item.status);

            return Container(
              constraints: const BoxConstraints(minHeight: 70),
              width: 260,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Texto do Status (lado esquerdo)
                  Expanded(
                    child: Text(
                      item.statusLabel,
                      softWrap: true,
                      style: textTheme.bodyMedium!.copyWith(
                        color: colorTheme.surface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Círculo com o número de processos (lado direito - posição oposta)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: colorTheme.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.amount.toString().padLeft(2, '0'),
                      style: textTheme.bodyMedium!.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}