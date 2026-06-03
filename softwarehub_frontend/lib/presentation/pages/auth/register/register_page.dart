import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/educational_institution_entity.dart';
import '../../../../domain/entities/types_link_entity.dart';
import '../../../../domain/entities/user/address_entity.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../shared/utils/responsive.dart';
import '../../../shared/utils/validators.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../users/controllers/user_logged_controller.dart';
import 'controllers/register_controller.dart';

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

  EducationalInstitutionEntity? selectedEducationalInstitution;
  TypesLinkEntity? selectedTypesLink;

  bool _showPassword = false;
  Worker? _userWorker;

  static const Color _primaryColor = Color(0xFF004294);

  @override
  void initState() {
    super.initState();

    registerController.fetchInitialData();

    if (!widget.isEditMode) {
      registerController.clearForm();
      registerController.clearEducationalInstitutionLinks();
    }

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

  TextStyle textThemeSafe(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(color: Colors.black87, fontSize: 15);
  }

  void _loadUserData() {
    final user = userControllerGet.user.value;

    if (user != null) {
      registerController.nameController.text = user.fullName;
      registerController.userController.text = user.userName;
      registerController.emailController.text = user.email;
      registerController.cpfController.text = user.cpf;
      registerController.professionController.text = user.profession;
      registerController.phoneController.text = user.phoneNumber;

      if (user.birthDate.isNotEmpty) {
        final parts = user.birthDate.split('-');

        if (parts.length == 3) {
          registerController.birthYearController.text = parts[0];
          registerController.birthMonthController.text = parts[1];
          registerController.birthDayController.text = parts[2];
        }
      }

      registerController.cepController.text = user.address.zipCode;
      registerController.streetController.text = user.address.street;
      registerController.complementController.text =
          user.address.complement ?? '';
      registerController.neighborhoodController.text =
          user.address.neighborhood;
      registerController.cityController.text = user.address.city;
      registerController.stateController.text = user.address.state;

      registerController.selectedEducationalInstitutionLinks.assignAll(
        user.userEducationalInstitutionLinks,
      );
    }
  }

  void _addEducationalInstitutionLink() {
    if (selectedEducationalInstitution == null || selectedTypesLink == null) {
      Get.snackbar(
        "Atenção",
        "Selecione uma instituição e um tipo de vínculo.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    registerController.addEducationalInstitutionLink(
      educationalInstitution: selectedEducationalInstitution!,
      typesLink: selectedTypesLink!,
    );

    setState(() {
      selectedEducationalInstitution = null;
      selectedTypesLink = null;
    });
  }

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
        color: theme.colorScheme.surface,
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

  Widget _dropdownField<T>({
    required String label,
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T item) itemLabel,
    required void Function(T? value) onChanged,
    IconData icon = Icons.arrow_drop_down_circle_outlined,
  }) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      dropdownColor: Colors.white,
      iconEnabledColor: _primaryColor,
      style: textThemeSafe(context).copyWith(
        color: Colors.black87,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        labelStyle: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(icon, color: _primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            itemLabel(item),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              itemLabel(item),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList();
      },
      onChanged: onChanged,
    );
  }

  Widget _institutionalLinksSection(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return _cardSection(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            "Vínculo institucional",
            widget.isEditMode
                ? "Atualize seus vínculos com instituições."
                : "Adicione uma ou mais instituições e seus tipos de vínculo.",
          ),

          const SizedBox(height: 14),

          if ((registerController.isLoadingEducationalInstitutions.value ||
                  registerController.isLoadingTypesLinks.value) &&
              (registerController.educationalInstitutions.isEmpty ||
                  registerController.typesLinks.isEmpty))
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _dropdownField<EducationalInstitutionEntity>(
                        label: "Instituição educacional",
                        hint: "Selecione uma instituição",
                        value: selectedEducationalInstitution,
                        items: registerController.educationalInstitutions,
                        itemLabel: (item) => item.name,
                        icon: Icons.account_balance_outlined,
                        onChanged: (value) {
                          setState(() {
                            selectedEducationalInstitution = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _dropdownField<TypesLinkEntity>(
                        label: "Tipo de vínculo",
                        hint: "Selecione o vínculo",
                        value: selectedTypesLink,
                        items: registerController.typesLinks,
                        itemLabel: (item) => item.name,
                        icon: Icons.link_outlined,
                        onChanged: (value) {
                          setState(() {
                            selectedTypesLink = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _addEducationalInstitutionLink,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Adicionar vínculo",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Obx(() {
                  final links =
                      registerController.selectedEducationalInstitutionLinks;

                  if (links.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        "Nenhum vínculo adicionado ainda.",
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: links.map((link) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.dividerColor.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_balance_outlined,
                              color: _primaryColor,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    link.educationalInstitution.name,
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    link.typesLink.name,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                registerController
                                    .removeEducationalInstitutionLink(link);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              tooltip: "Remover vínculo",
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }

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

        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DiagonalLinesPainter(
                  color: Colors.black.withOpacity(0.04),
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
                                        controller:
                                            registerController.nameController,
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
                                        controller:
                                            registerController.userController,
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
                                  controller:
                                      registerController.emailController,
                                  label: "E-mail",
                                  hintText: "exemplo@outlook.com",
                                  size: 724,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validators.email,
                                  prefixIcon: const Icon(Icons.mail_outline),
                                ),

                                CustomTextField(
                                  controller: registerController.cpfController,
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
                                        controller: registerController
                                            .professionController,
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
                                        controller:
                                            registerController.phoneController,
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
                                        controller: registerController
                                            .birthDayController,
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
                                        controller: registerController
                                            .birthMonthController,
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
                                        controller: registerController
                                            .birthYearController,
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

                                CustomTextField(
                                  controller: registerController.passwordController,
                                  label: widget.isEditMode
                                      ? "Nova Senha (deixe em branco para manter)"
                                      : "Senha",
                                  hintText: "********",
                                  size: 270,
                                  obscureText: !_showPassword,
                                  validator: (v) {
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
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
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

                          _institutionalLinksSection(context),

                          const SizedBox(height: 16),

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

                                CustomTextField(
                                  controller: registerController.cepController,
                                  label: "CEP",
                                  hintText: "00000-000",
                                  size: 500,
                                  keyboardType: TextInputType.number,
                                  validator: Validators.cep,
                                  prefixIcon: const Icon(
                                    Icons.pin_drop_outlined,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final address = await registerController
                                            .getByZipCode(registerController.cepController.text);

                                        if (address != null) {
                                          registerController.streetController.text =
                                              address.street;
                                          registerController.neighborhoodController.text =
                                              address.neighborhood;
                                          registerController.cityController.text = address.city;
                                          registerController.stateController.text = address.state;
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryColor,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.search,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Buscar CEP",
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                _gap(),

                                CustomTextField(
                                  controller: registerController.streetController,
                                  label: "Rua",
                                  size: 500,
                                  validator: Validators.required,
                                  prefixIcon: const Icon(
                                    Icons.signpost_outlined,
                                  ),
                                ),

                                _gap(),

                                CustomTextField(
                                  controller: registerController.neighborhoodController,
                                  label: "Bairro / Setor",
                                  size: 500,
                                  validator: Validators.required,
                                  prefixIcon: const Icon(Icons.map_outlined),
                                ),

                                _gap(),

                                CustomTextField(
                                  controller: registerController.complementController,
                                  label: "Complemento",
                                  hintText: "Opcional",
                                  size: 500,
                                  validator: (v) => null,
                                  prefixIcon: const Icon(
                                    Icons.location_on_outlined,
                                  ),
                                ),

                                _gap(),

                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller:registerController. cityController,
                                        label: "Município",
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
                                        controller:registerController. stateController,
                                        label: "Estado (UF)",
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

                          Obx(() {
                            return SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shadowColor: Colors.black.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                    ),
                                  ),
                                ),
                                icon: registerController.isLoadingSubmit.value
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      )
                                    : const Icon(Icons.save_outlined),
                                onPressed:
                                    registerController.isLoadingSubmit.value
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (!registerController
                                              .hasEducationalInstitutionLinks) {
                                            Get.snackbar(
                                              "Atenção",
                                              "Adicione pelo menos um vínculo institucional.",
                                              snackPosition: SnackPosition.TOP,
                                            );
                                            return;
                                          }

                                          final userEntityToSave = UserEntity(
                                            userName: registerController.userController.text,
                                            email: registerController.emailController.text,
                                            cpf: registerController.cpfController.text,
                                            password:registerController. passwordController.text,
                                            phoneNumber:registerController. phoneController.text,
                                            birthDate:
                                                "${registerController.birthYearController.text}-"
                                                "${registerController.birthMonthController.text.padLeft(2, '0')}-"
                                                "${registerController.birthDayController.text.padLeft(2, '0')}",
                                            profession:
                                                registerController.professionController.text,
                                            fullName: registerController.nameController.text,
                                            role:
                                                userControllerGet.user.value !=
                                                    null
                                                ? userControllerGet
                                                      .user
                                                      .value!
                                                      .role
                                                : 'USER',
                                            isEnabled: true,
                                            userEducationalInstitutionLinks:
                                                registerController
                                                    .getSelectedEducationalInstitutionLinks(),
                                            address: AddressEntity(
                                              zipCode: registerController.cepController.text,
                                              street: registerController.streetController.text,
                                              complement:
                                                  registerController.complementController.text,
                                              neighborhood:
                                                  registerController.neighborhoodController.text,
                                              city: registerController.cityController.text,
                                              state: registerController.stateController.text,
                                            ),
                                          );

                                          if (widget.isEditMode) {
                                            await registerController
                                                .updateUserLogged(
                                                  userControllerGet
                                                      .user
                                                      .value!
                                                      .id!,
                                                  userEntityToSave,
                                                );
                                          } else {
                                            await registerController.post(
                                              userEntityToSave,
                                            );
                                          }
                                        }
                                      },
                                label: Text(
                                  registerController.isLoadingSubmit.value
                                      ? widget.isEditMode
                                            ? "Atualizando..."
                                            : "Salvando..."
                                      : widget.isEditMode
                                      ? "Atualizar Perfil"
                                      : "Salvar cadastro",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
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
