import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/application_field_controller.dart';

class ApplicationFieldSearchCard extends StatelessWidget {
  final ApplicationFieldController controller;

  const ApplicationFieldSearchCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CABEÇALHO DO CARD ---
          const Text(
            "Pesquisar campos",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Encontre áreas ou campos por nome",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 24),

          // --- CAMPO DE PESQUISA COM BOTÃO EXPLÍCITO ---
          const Text(
            "Buscar por nome",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  onSubmitted: controller.searchByName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite o nome do campo...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                    suffixIcon: Obx(() {
                      final hasSearch = controller.search.value.isNotEmpty;

                      if (hasSearch) {
                        return IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                          onPressed: () {
                            controller.clearSearch();
                            controller.searchController.clear();
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ),
                ),
              ),

              const SizedBox(width: 12),


              SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.searchByName(controller.searchController.text);
                  },
                  icon: const Icon(Icons.search, size: 17),
                  label: const Text(
                    "Buscar",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}