import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/password_reset/controllers/password_reset_controller.dart';
import '../../../shared/widgets/custom_text_field.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/shared_background.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final passwordResetController = Get.find<PasswordResetController>();

  // Cor padrão da barra azul definida aqui para uso no AppBar
  static const Color _primaryColor = Color(0xFF004294);

  @override
  void dispose() {
    super.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: _primaryColor,
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
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Trocar senha",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Crie uma nova senha de acesso",
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),


      body: SharedBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.vpn_key_outlined,
                      size: 36,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Criar nova senha",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Informe o código que enviamos para o seu e-mail e digite sua nova senha.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    controller: _tokenController,
                    label: "Código recebido",
                    prefixIcon: const Icon(Icons.numbers_rounded),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _newPasswordController,
                    label: "Nova senha",
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  const SizedBox(height: 32),

                  // Botão Enviar
                  Obx(
                        () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: passwordResetController.loading.value
                            ? null
                            : () {
                          passwordResetController.passwordReset(
                            _tokenController.text,
                            _newPasswordController.text,
                          );
                          _tokenController.clear();
                          _newPasswordController.clear();
                        },
                        icon: passwordResetController.loading.value
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Icon(Icons.check_circle_outline, size: 20),
                        label: Text(
                          passwordResetController.loading.value
                              ? "Salvando..."
                              : "Redefinir Senha",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Mensagem de retorno
                  Obx(() {
                    final message = passwordResetController.message.value;
                    if (message.isEmpty) return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}