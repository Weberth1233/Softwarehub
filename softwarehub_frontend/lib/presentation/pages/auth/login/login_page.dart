import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/widgets/diagonal_lines_painter.dart';
import 'controllers/login_controller.dart';
import 'widgets/action_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(
    text: 'lucas.fernandes@emailteste.com',
  );
  final _passwordController = TextEditingController(text: 'Lucas2026');

  final loginController = Get.find<LoginController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Background clean gradiente + sombra suave
  Widget _cleanBackground(ThemeData theme) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF7CB6E1), // azul claro (topo)
            Color(0xFF005A9C), // azul institucional (meio)
            Color(0xFFC79E33), // ouro velho/mostarda (transição direta, sem branco)
            Color(0xFFFBC02D), // dourado (base)
          ],
          // Dando mais espaço para o azul antes de iniciar a transição para o dourado
          stops: [0.0, 0.60, 0.85, 1.0],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required ThemeData theme,
    required String hint,
    required IconData icon,
  }) {
    final colors = theme.colorScheme;

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: colors.primary.withOpacity(0.75)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.primary.withOpacity(0.55),
          width: 1.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      body: Stack(
          children: [
          _cleanBackground(theme),

      Positioned.fill(
        child: CustomPaint(
          painter: DiagonalLinesPainter(
            color: theme.colorScheme.onSecondary.withOpacity(0.030),
          ),
        ),
      ),

      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 28,
                      spreadRadius: 0,
                      offset: const Offset(0, 14),
                      color: Colors.black.withOpacity(0.12),
                    ),
                  ],
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const _AnimatedTopAccentBar(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                  child: Column(
                      children: [
                  // Logo
                  Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: SvgPicture.asset(
                    "assets/images/logo_sgpi.svg",
                    height: 340,
                    fit: BoxFit
                        .contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                //
                Transform.translate(
                  offset: const Offset(0, 8),
                  child: Text(
                    "𝗦𝗢𝗙𝗧𝗪𝗔𝗥𝗘 𝗛𝗨𝗕",
                    style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  fontSize: 30,
                    height:
                    0.8,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Campo Usuário / Email
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "E-mail",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.primary.withOpacity(0.85),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: _fieldDecoration(
                  theme: theme,
                  hint: "Seu email ...",
                  icon: Icons.person_outline,
                ),
              ),

              const SizedBox(height: 16),

              // Campo Senha
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Senha",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.primary.withOpacity(0.85),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                obscureText: true,
                decoration: _fieldDecoration(
                  theme: theme,
                  hint: "Digite sua senha",
                  icon: Icons.lock_outline,
                ),
              ),

              const SizedBox(height: 16),

              // Erro (mesma lógica)
              Obx(() {
                final error =
                    loginController.errorMessage.value;
                if (error.isEmpty) {
                  return const SizedBox(height: 0);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),

              // Botão Entrar (mesma lógica)
              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: loginController.loading.value
                        ? null
                        : () {
                      loginController.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    icon: loginController.loading.value
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(Icons.login),
                    label: Text(
                      loginController.loading.value
                          ? "Entrando..."
                          : "Entrar",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ActionButtons(),
              ],
            ),
          ),
          ],
        ),
      ),
    ),
    ),
    ),
    ),
    ],
    ),
    );
  }
}

/// Barra decorativa animada no topo do card de login.
/// As 3 cores (azul, branco, dourado) fluem continuamente da esquerda
/// para a direita, dando uma sensação de "energia" ao card.
class _AnimatedTopAccentBar extends StatefulWidget {
  const _AnimatedTopAccentBar();

  @override
  State<_AnimatedTopAccentBar> createState() => _AnimatedTopAccentBarState();
}

class _AnimatedTopAccentBarState extends State<_AnimatedTopAccentBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;


  static const _barColors = [
    Color(0xFF00B0FF), // azul
    Colors.white, // branco
    Color.fromARGB(255, 223, 174, 16),
    Color(0xFF00B0FF), // azul (fecha o ciclo)
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final slidePercent = (_controller.value * 2) - 1;

        return Container(
          height: 6,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: _barColors,
              tileMode: TileMode.mirror,
              transform: _SlidingGradientTransform(slidePercent: slidePercent),
            ),
          ),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}