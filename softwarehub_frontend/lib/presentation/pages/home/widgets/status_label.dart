import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme/theme_color.dart';
import '../controllers/home_controller.dart';

class StatusLabel extends StatelessWidget {
  final ProcessController processController;

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
        return Colors.green;

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
              height: 55,
              width: 260,
              padding: const EdgeInsets.only(left: 20, right: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.statusLabel,
                      style: const TextStyle(
                        decorationColor: ThemeColor.greyColor,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.amount.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
