import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class FilterCard extends StatefulWidget {
  const FilterCard({super.key});

  @override
  State<FilterCard> createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  final List<String> filters = [
    "Todos",
    "Aguardando distribuição de cotas",
    "Cotas distribuídas",
    "Em correção",
    "Corrigido",
    "Classificado",
    "Documentação pendente",
    "Finalizado",
  ];
  int selectedIndex = 0;

  final TextEditingController controller = TextEditingController();
  final processController = Get.find<ProcessController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return SizedBox(
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _title(context),
                const SizedBox(height: 12),
                _buildFilters(context),
                const SizedBox(height: 12),
                _buildSearch(context, controller),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title(context),
                      const SizedBox(height: 12),
                      _buildFilters(context),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(width: 280, child: _buildSearch(context, controller)),
              ],
            ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visão Geral",
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Filtre pelo status do seu processo",
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          final isFirst = index == 0;
          final isLast = index == filters.length - 1;

          BorderRadius radius;
          if (isFirst) {
            radius = const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            );
          } else if (isLast) {
            radius = const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            );
          } else {
            radius = BorderRadius.zero;
          }

          return InkWell(
            borderRadius: radius,
            onTap: () {
              setState(() => selectedIndex = index);
              final statusMap = {
                0: "",
                1: "PENDENTE_DISTRIBUICAO_COTAS",
                2: "COTAS_DISTRIBUIDAS",
                3: "CORRECAO",
                4: "CORRIGIDO",
                5: "CLASSIFICADO",
                6: "PENDENTE_DOCUMENTACAO",
                7: "FINALIZADO",
              };
              processController.filterByStatus(statusMap[index]!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: radius,
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: "Pesquisar...",
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
        prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
        ),
      ),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) => processController.searchByTitle(value),
    );
  }
}
