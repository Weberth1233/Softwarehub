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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller.searchController,
        onSubmitted: controller.searchByName,
        decoration: InputDecoration(
          labelText: 'Pesquisar campo',
          hintText: 'Ex: Administração',
          prefixIcon: Icon(
            Icons.search,
            color: colors.primary,
          ),
          labelStyle: TextStyle(
            color: colors.secondary,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: TextStyle(
            color: colors.secondary.withOpacity(0.7),
          ),
          filled: true,
          fillColor: colors.primary.withOpacity(0.04),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.06),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.06),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: colors.primary.withOpacity(0.45),
              width: 1.4,
            ),
          ),
          suffixIcon: Obx(() {
            final hasSearch = controller.search.value.isNotEmpty;

            if (hasSearch) {
              return IconButton(
                icon: Icon(
                  Icons.close,
                  color: colors.secondary,
                ),
                onPressed: controller.clearSearch,
              );
            }

            return IconButton(
              icon: Icon(
                Icons.search,
                color: colors.primary,
              ),
              onPressed: () {
                controller.searchByName(
                  controller.searchController.text,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}