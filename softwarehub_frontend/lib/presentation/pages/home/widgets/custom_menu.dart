import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../infra/datasources/auth_local_datasource.dart';
import '../../../core/routes/app_routes.dart';
import '../../users/controllers/user_logged_controller.dart';

class CustomMenu extends StatelessWidget implements PreferredSizeWidget {
  const CustomMenu({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(90);

  String _getFirstTwoNames(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) {
      return "Usuário";
    }

    final names = fullName.trim().split(RegExp(r'\s+'));

    if (names.length >= 2) {
      return "${names[0]} ${names[1]}";
    }

    return names.first;
  }

  String _getInitial(String? fullName) {
    final firstName = _getFirstTwoNames(fullName);

    if (firstName.isEmpty || firstName == "Usuário") {
      return "U";
    }

    return firstName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserLoggedController>();
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
            child: RichText(
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
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 20),
          child: Obx(() {
            final user = userController.user.value;

            final firstName = _getFirstTwoNames(user?.fullName);
            final initial = _getInitial(user?.fullName);

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.userLogged);
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        textAlign: TextAlign.center,
                        initial,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  firstName,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const CustomPopMenuButton(),
              ],
            );
          }),
        ),
      ],
    );
  }
}

class CustomPopMenuButton extends StatelessWidget {
  const CustomPopMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authLocalDataSource = Get.find<AuthLocalDataSource>();

    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      tooltip: 'Mais opções',
      icon: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: theme.colorScheme.primary,
        ),
      ),
      onSelected: (value) {
        if (value == 'profile') {
          Get.toNamed(AppRoutes.userLogged);
        } else if (value == 'logout') {
          authLocalDataSource.clear();
          Get.offAllNamed("/login");
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 10),
              Text('Perfil', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: theme.colorScheme.primary),
              SizedBox(width: 10),
              Text('Sair', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
