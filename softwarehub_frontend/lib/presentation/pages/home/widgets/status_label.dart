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

  IconData getStatusIcon(String status) {
    switch (status) {
      case "PENDENTE_DISTRIBUICAO_COTAS":
        return Icons.pending;

      case "COTAS_DISTRIBUIDAS":
        return Icons.pie_chart_outline;

      case "CORRECAO":
        return Icons.approval;

      case "CORRIGIDO":
        return Icons.task_alt_rounded;

      case "CLASSIFICADO":
        return Icons.category_outlined;

      case "FINALIZADO":
        return Icons.check_circle_outline;

      case "INATIVO":
        return Icons.pie_chart_outline;

      case "PENDENTE_DOCUMENTACAO":
        return Icons.document_scanner;

      default:
        return Icons.g_mobiledata;
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
              height: 70,
              width: 260,
              padding: const EdgeInsets.only(left: 20, right: 6),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(getStatusIcon(item.status), size: 30,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.statusLabel,
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorTheme.surface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                        item.amount.toString().padLeft(2, '0'),
                        style: textTheme.bodyMedium!.copyWith(
                            color: colorTheme.surface,
                          ),
                          
                      ),
                      ],
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
