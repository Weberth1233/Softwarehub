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
    text: 'marialurdes123@gmail.com',
  );
  final _passwordController = TextEditingController(text: 'marialurdes123');

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
            Color.fromARGB(205, 124, 182, 225),
            Color.fromARGB(255, 22, 117, 185),
            Color(0xFF005A9C),
            Color(0xFFFBC02D),
          ],
        ),
      ),
    );
  }

  Widget _topAccentBar() {
    return Container(
      height: 6,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        gradient: LinearGradient(
          colors: [
            Color(0xFF00B0FF), // azul
            Colors.white, // branco
            Color.fromARGB(255, 223, 174, 16),
          ],
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
                        _topAccentBar(),

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
                                      .contain, // Isso força o SVG a respeitar o tamanho de 60x65
                                  alignment: Alignment.bottomCenter,
                                ),
                              ),
                              //
                              Transform.translate(
                                offset: const Offset(0, 8),
                                // Puxa o texto 40 pixels para cima
                                child: Text(
                                  "𝗦𝗢𝗙𝗧𝗪𝗔𝗥𝗘 𝗛𝗨𝗕",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    fontSize: 30,
                                    height:
                                        0.8, // Diminui a altura da linha do próprio texto
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
