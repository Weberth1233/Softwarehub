import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../core/routes/app_routes.dart';

class CustomMenu extends StatefulWidget {
  const CustomMenu({super.key});

  @override
  State<CustomMenu> createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  final authLocalDataSource = Get.find<AuthLocalDataSource>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: theme.colorScheme.primary,
      elevation: 10,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 90,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      titleSpacing: 24,
      title: Row(
        children: [
          SvgPicture.asset(
            "assets/images/logo_sgpi.svg",
            width: 60,
            height: 65,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Bem-Vindo ",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 35,
                          fontWeight: FontWeight.w300,
                          color: theme.colorScheme.primary.withOpacity(0.6),
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: "Software",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.primary.withOpacity(0.9),
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: "Hub",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 30,
                          color: const Color(0xFFFDAA51),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        FutureBuilder<String?>(
          future: authLocalDataSource.getRole(),
          builder: (context, snapshot) {
            final isAdmin = snapshot.data == 'ADMIN';
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isAdmin ? "ADMIN" : "USUÁRIO",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.userLogged);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(40, 40),
                    ),
                    icon: const Icon(Icons.person, size: 45),
                  ),
                  const SizedBox(width: 18.5),
                  Container(
                    height: 70,
                    width: 1.6,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 13),
                  TextButton.icon(
                    onPressed: () {
                      authLocalDataSource.clear();
                      Get.offAllNamed("/login");
                    },
                    icon: Icon(
                      Icons.logout_rounded,
                      color: theme.colorScheme.primary,
                      size: 36,
                    ),
                    label: Text(
                      "Sair",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
