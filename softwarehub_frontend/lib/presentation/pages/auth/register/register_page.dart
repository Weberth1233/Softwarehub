import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/address_entity.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/auth/register/controllers/register_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/custom_text_field.dart';
import '../../../shared/utils/responsive.dart';
import '../../../shared/utils/validators.dart';
import 'package:flutter/services.dart';

import '../../users/controllers/user_logged_controller.dart';

class RegisterPage extends StatefulWidget {
  final bool isEditMode;

  const RegisterPage({super.key, this.isEditMode = false});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final registerController = Get.find<RegisterController>();
  final userControllerGet = Get.find<UserLoggedController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController cepController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  // Data de nascimento (manual)
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController birthMonthController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();

  bool _showPassword = false;
  Worker? _userWorker;

  // Cor padrão da barra azul definida aqui para uso no AppBar
  static const Color _primaryColor = Color(0xFF004294);

  @override
  void initState() {
    super.initState();
    // Se for modo de edição, carrega os dados do usuário logado nos controllers
    if (widget.isEditMode) {
      if (userControllerGet.user.value != null) {
        _loadUserData();
      }
      _userWorker = ever(userControllerGet.user, (user) {
        if (user != null) {
          _loadUserData();
        }
      });
    }
  }

  void _loadUserData() {
    final user = userControllerGet.user.value;
    if (user != null) {
      nameController.text = user.fullName;
      userController.text = user.userName;
      emailController.text = user.email;
      cpfController.text = user.cpf;
      professionController.text = user.profession;
      phoneController.text = user.phoneNumber;

      // Tratando a data de nascimento assumindo formato YYYY-MM-DD
      if (user.birthDate.isNotEmpty) {
        final parts = user.birthDate.split('-');
        if (parts.length == 3) {
          birthYearController.text = parts[0];
          birthMonthController.text = parts[1];
          birthDayController.text = parts[2];
        }
      }

      // Tratando o endereço
      cepController.text = user.address.zipCode;
      streetController.text = user.address.street;
      numberController.text = user.address.number;
      complementController.text = user.address.complement ?? '';
      neighborhoodController.text = user.address.neighborhood;
      cityController.text = user.address.city;
      stateController.text = user.address.state;
    }
  }

  @override
  void dispose() {
    _userWorker?.dispose();
    nameController.dispose();
    userController.dispose();
    emailController.dispose();
    cpfController.dispose();
    professionController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    birthDayController.dispose();
    birthMonthController.dispose();
    birthYearController.dispose();

    cepController.dispose();
    streetController.dispose();
    numberController.dispose();
    complementController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();

    super.dispose();
  }

  void clearForm() {
    userController.clear();
    nameController.clear();
    emailController.clear();
    cpfController.clear();
    professionController.clear();
    phoneController.clear();
    passwordController.clear();
    birthDayController.clear();
    birthMonthController.clear();
    birthYearController.clear();

    cepController.clear();
    streetController.clear();
    numberController.clear();
    complementController.clear();
    neighborhoodController.clear();
    cityController.clear();
    stateController.clear();
  }

  // =======================
  // UI helpers
  // =======================
  Widget _sectionHeader(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _cardSection(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Branco
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.12)),
      ),
      child: child,
    );
  }

  Widget _gap() => const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Obx(() {
      if (registerController.message.value.isNotEmpty) {
        Future.microtask(() {
          Get.snackbar(
            widget.isEditMode ? "Atualização" : "Cadastro",
            registerController.message.value,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
            backgroundColor: const Color(0xFFCBD5E1),
            colorText: theme.colorScheme.primary,
            margin: const EdgeInsets.all(12),
            borderRadius: 12,
          );
          registerController.message.value = "";
        });
      }

      return Scaffold(
        // Fundo claro para contrastar com os cartões e destacar a textura
        backgroundColor: Color(0xFFCBD5E1),

        // ===== NOVO APPBAR (BARRA AZUL) =====
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
                      widget.isEditMode
                          ? "Edite seu perfil"
                          : "Cadastro de usuários",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isEditMode
                          ? "Atualize suas informações no sistema"
                          : "Preencha os dados para criar uma nova conta",
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

        // ===== CORPO DA PÁGINA (COM BACKGROUND TEXTURIZADO) =====
        body: Stack(
          children: [
            // 1. Textura de fundo (Diagonal Lines)
            Positioned.fill(
              child: CustomPaint(
                painter: _DiagonalLinesPainter(
                  color: Colors.black.withOpacity(0.04), // Textura sutil
                ),
              ),
            ),

            Positioned.fill(
              child: SingleChildScrollView(
                child: Container(
                  padding: Responsive.getPadding(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardSection(
                            context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader(
                                  context,
                                  "Dados do usuário",
                                  widget.isEditMode
                                      ? "Atualize suas informações pessoais."
                                      : "Preencha as informações para criar sua conta.",
                                ),

                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: nameController,
                                        label: "Nome completo",
                                        hintText: "Seu nome aqui",
                                        size: 724,
                                        validator: (v) => Validators.required(
                                          v,
                                          message: "Informe o nome completo",
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.badge_outlined,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: CustomTextField(
                                        controller: userController,
                                        label: "Nome de usuário",
                                        size: 600,
                                        validator: (v) => Validators.required(
                                          v,
                                          message: "Informe o nome de usuário",
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.alternate_email,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                _gap(),

                                CustomTextField(
                                  controller: emailController,
                                  label: "E-mail",
                                  hintText: "exemplo@outlook.com",
                                  size: 724,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.email,
                                  prefixIcon: const Icon(Icons.mail_outline),
                                ),

                                CustomTextField(
                                  controller: cpfController,
                                  label: "CPF",
                                  hintText: "00000000000",
                                  size: 724,
                                  keyboardType: TextInputType.number,
                                  validator: Validators.cpf,
                                  prefixIcon: const Icon(Icons.person),
                                ),

                                _gap(),

                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: professionController,
                                        label: "Profissão",
                                        size: 724,
                                        validator: Validators.required,
                                        prefixIcon: const Icon(
                                          Icons.work_outline,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextField(
                                        controller: phoneController,
                                        label: "Telefone",
                                        size: 200,
                                        hintText: "(dd) 0 0000 0000",
                                        keyboardType: TextInputType.phone,
                                        validator: Validators.phone,
                                        prefixIcon: const Icon(
                                          Icons.phone_outlined,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                _gap(),

                                // ===== Data de nascimento (manual: Dia/Mês/Ano)
                                Text(
                                  "Data de nascimento :",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.tertiary,
                                      ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: CustomTextField(
                                        controller: birthDayController,
                                        label: "",
                                        hintText: "Dia",
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(2),
                                        ],
                                        validator: (v) {
                                          final d = int.tryParse(v ?? "");
                                          if (d == null) return "Inválido";
                                          if (d < 1 || d > 31) return "1-31";
                                          return null;
                                        },
                                        prefixIcon: const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 100,
                                      child: CustomTextField(
                                        controller: birthMonthController,
                                        label: "",
                                        hintText: "Mês",
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(2),
                                        ],
                                        validator: (v) {
                                          final m = int.tryParse(v ?? "");
                                          if (m == null) return "Inválido";
                                          if (m < 1 || m > 12) return "1-12";
                                          return null;
                                        },
                                      ),
                                    ),

                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 150,
                                      child: CustomTextField(
                                        controller: birthYearController,
                                        label: "",
                                        hintText: "Ano",
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        validator: (v) {
                                          final y = int.tryParse(v ?? "");
                                          final nowY = DateTime.now().year;
                                          if (y == null) return "Inválido";
                                          if (y < 1900 || y > nowY) {
                                            return "1900-$nowY";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // ===== Senha
                                CustomTextField(
                                  controller: passwordController,
                                  label: widget.isEditMode
                                      ? "Nova Senha (deixe em branco para manter)"
                                      : "Senha",
                                  hintText: "********",
                                  size: 270,
                                  obscureText: !_showPassword,
                                  validator: (v) {
                                    // Se estiver editando e o campo estiver vazio, não valida a senha
                                    if (widget.isEditMode &&
                                        (v == null || v.isEmpty)) {
                                      return null;
                                    }
                                    return Validators.minLength(
                                      v,
                                      6,
                                      message:
                                          "Senha deve ter no mínimo 6 caracteres",
                                    );
                                  },
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() {
                                      _showPassword = !_showPassword;
                                    }),
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ===== Seção: Endereço
                          _cardSection(
                            context,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionHeader(
                                  context,
                                  "Endereço",
                                  widget.isEditMode
                                      ? "Atualize seu endereço."
                                      : "Informe seu endereço para concluir o cadastro.",
                                ),

                                const SizedBox(height: 14),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomTextField(
                                      controller: cepController,
                                      label: "CEP",
                                      hintText: "00000-000",
                                      size: 500,
                                      keyboardType: TextInputType.number,
                                      validator: Validators.cep,
                                      prefixIcon: const Icon(
                                        Icons.pin_drop_outlined,
                                      ),
                                    ),
                                    SizedBox(width: 20),

                                    ElevatedButton(
                                      onPressed: () async {
                                        final address = await registerController
                                            .getByZipCode(cepController.text);

                                        if (address != null) {
                                          streetController.text =
                                              address.street;
                                          neighborhoodController.text =
                                              address.neighborhood;
                                          cityController.text = address.city;
                                          stateController.text = address.state;
                                        }
                                      },
                                      child: Text(
                                        "Buscar por CEP",
                                        style: textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                CustomTextField(
                                  controller: streetController,
                                  label: "Rua",
                                  size: 500,
                                  validator: Validators.required,
                                  prefixIcon: const Icon(
                                    Icons.signpost_outlined,
                                  ),
                                ),
                                _gap(),

                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: numberController,
                                        label: "Número",
                                        size: 500,
                                        keyboardType: TextInputType.number,
                                        validator: Validators.required,
                                        prefixIcon: const Icon(
                                          Icons.confirmation_number_outlined,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: CustomTextField(
                                        controller: complementController,
                                        label: "Complemento (opcional)",
                                        size: 500,
                                        validator: (v) => null,
                                        prefixIcon: const Icon(
                                          Icons.add_location_alt_outlined,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                _gap(),

                                CustomTextField(
                                  controller: neighborhoodController,
                                  label: "Setor / Bairro",
                                  size: 500,
                                  validator: Validators.required,
                                  prefixIcon: const Icon(Icons.map_outlined),
                                ),

                                _gap(),

                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: cityController,
                                        label: "Cidade",
                                        size: 500,
                                        validator: Validators.required,
                                        prefixIcon: const Icon(
                                          Icons.location_city_outlined,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    Expanded(
                                      child: CustomTextField(
                                        controller: stateController,
                                        label: "Estado",
                                        size: 500,
                                        validator: Validators.required,
                                        prefixIcon: const Icon(
                                          Icons.flag_outlined,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ===== CTA
                          Obx(() {
                            return SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: theme.colorScheme.primary,
                                  elevation: 2, // Ajustado para ser mais sutil
                                  shadowColor: Colors.black.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                icon: registerController.isLoading.value
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.colorScheme.primary,
                                        ),
                                      )
                                    : const Icon(Icons.save_outlined),
                                onPressed: registerController.isLoading.value
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          final userEntityToSave = UserEntity(
                                            userName: userController.text,
                                            email: emailController.text,
                                            cpf: cpfController.text,
                                            password: passwordController.text,
                                            phoneNumber: phoneController.text,
                                            birthDate:
                                                "${birthYearController.text}-"
                                                "${birthMonthController.text.padLeft(2, '0')}-"
                                                "${birthDayController.text.padLeft(2, '0')}",
                                            profession:
                                                professionController.text,
                                            fullName: nameController.text,
                                            role:
                                                userControllerGet.user.value !=
                                                    null
                                                ? userControllerGet
                                                      .user
                                                      .value!
                                                      .role
                                                : 'USER',
                                            isEnabled: true,
                                            userEducationalInstitutionLinks: [],
                                            address: AddressEntity(
                                              zipCode: cepController.text,
                                              street: streetController.text,
                                              number: numberController.text,
                                              complement:
                                                  complementController.text,
                                              neighborhood:
                                                  neighborhoodController.text,
                                              city: cityController.text,
                                              state: stateController.text,
                                            
                                            ),
                                          );
                                          print(userEntityToSave.role);
                                          if (widget.isEditMode) {
                                            print(
                                              userControllerGet.user.value!.id!,
                                            );
                                            // Chamar método de Update (certifique-se de que ele existe no seu RegisterController)
                                            registerController.updateUserLogged(
                                              userControllerGet.user.value!.id!,
                                              userEntityToSave,
                                            );
                                          } else {
                                            registerController.post(
                                              userEntityToSave,
                                            );
                                            clearForm();
                                          }
                                        }
                                      },

                                label: Text(
                                  registerController.isLoading.value
                                      ? (widget.isEditMode
                                            ? "Atualizando..."
                                            : "Salvando...")
                                      : (widget.isEditMode
                                            ? "Atualizar Perfil"
                                            : "Salvar cadastro"),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
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
            ),
          ],
        ),
      );
    });
  }
}

// =======================
// Custom Painter: Linhas Diagonais
// =======================
class _DiagonalLinesPainter extends CustomPainter {
  final Color color;

  _DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const spacing = 80.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
