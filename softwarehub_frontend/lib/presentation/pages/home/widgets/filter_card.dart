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

  final Map<int, String> statusMap = {
    0: "",
    1: "PENDENTE_DISTRIBUICAO_COTAS",
    2: "COTAS_DISTRIBUIDAS",
    3: "CORRECAO",
    4: "CORRIGIDO",
    5: "CLASSIFICADO",
    6: "PENDENTE_DOCUMENTACAO",
    7: "FINALIZADO",
  };

  int selectedIndex = 0;

  final int visibleFiltersCount = 4;

  final TextEditingController controller = TextEditingController();
  final ProcessController processController = Get.find<ProcessController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onFilterTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    final status = statusMap[index] ?? "";
    processController.filterByStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context),
        const SizedBox(height: 14),
        if (isMobile) ...[
          _buildFilterArea(context),
          const SizedBox(height: 14),
          _buildSearch(context, controller),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _buildFilterArea(context),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 280,
                height: 38,
                child: _buildSearch(context, controller),
              ),
            ],
          ),
      ],
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
            height: 1.1,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Filtre pelo status do seu processo",
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterArea(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
      ),
      child: _buildFilters(context),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final visibleIndexes = List.generate(visibleFiltersCount, (index) => index);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          ...visibleIndexes.map(
            (index) => _filterTab(context, index),
          ),
          _moreFilterButton(context),
        ],
      ),
    );
  }

  Widget _filterTab(BuildContext context, int index) {
    final colors = Theme.of(context).colorScheme;
    final isSelected = selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onFilterTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? colors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          filters[index],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? colors.primary : const Color(0xFF111827),
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _moreFilterButton(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final moreIndexes = List.generate(
      filters.length - visibleFiltersCount,
      (index) => index + visibleFiltersCount,
    );

    final isMoreSelected = selectedIndex >= visibleFiltersCount;

    return PopupMenuButton<int>(
      tooltip: "Mais filtros",
      offset: const Offset(0, 44),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      onSelected: _onFilterTap,
      itemBuilder: (context) {
        return moreIndexes.map((index) {
          final isSelected = selectedIndex == index;

          return PopupMenuItem<int>(
            value: index,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    filters[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected ? colors.primary : const Color(0xFF111827),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isMoreSelected ? colors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              "Mais",
              style: TextStyle(
                fontSize: 15,
                color: isMoreSelected ? colors.primary : const Color(0xFF111827),
                fontWeight: isMoreSelected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: isMoreSelected ? colors.primary : const Color(0xFF111827),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF111827),
      ),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: "Pesquisar...",
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 21,
          color: Color(0xFF6B7280),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 38,
          minHeight: 38,
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.3,
          ),
        ),
      ),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) {
        processController.searchByTitle(value.trim());
      },
    );
  }
}