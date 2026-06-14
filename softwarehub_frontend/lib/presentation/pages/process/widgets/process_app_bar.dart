import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/theme/theme_color.dart';

class ProcessAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditMode;

  const ProcessAppBar({
    super.key,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      backgroundColor: ThemeColor.primaryColor,
      automaticallyImplyLeading: false,
      toolbarHeight: 74,
      titleSpacing: 12,
      title: Row(
        children: [
          SizedBox(
            height: 46,
            width: 46,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.arrow_back, color: Colors.grey.shade900),
                onPressed: () => Get.back(),
                tooltip: "Voltar",
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditMode ? "Editar Processo" : "Cadastro de Processo",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(74);
}