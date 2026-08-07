import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/external_author_entity.dart';
import '../../shared/formatters/mask_text_input_formatter.dart';
import '../../shared/utils/app_toast.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/utils/validators.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/shared_background.dart';
import 'controllers/process_external_author_controller.dart';

class ProcessExternalAuthorFormPage extends StatefulWidget {
  const ProcessExternalAuthorFormPage({super.key});

  @override
  State<ProcessExternalAuthorFormPage> createState() =>
      _ProcessExternalAuthorFormPageState();
}

class _ProcessExternalAuthorFormPageState
    extends State<ProcessExternalAuthorFormPage> {
  final controller = Get.find<ProcessExternalAuthorController>();
  final _formKey = GlobalKey<FormState>();

  final ExternalAuthorEntity? editingEntity =
  Get.arguments as ExternalAuthorEntity?;

  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController cpfController;

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(text: editingEntity?.fullName);
    emailController = TextEditingController(text: editingEntity?.email);
    cpfController = TextEditingController(
      text: editingEntity?.cpf == null
          ? null
          : InputMasks.cpf.maskText(editingEntity!.cpf),
    );
  }

  bool get isEditing => editingEntity != null;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final entity = ExternalAuthorEntity(
        id: editingEntity?.id,
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        cpf: InputMasks.onlyNumbers(cpfController.text),
      );

      final bool isSuccess = isEditing
          ? await controller.updateExternalAuthor(entity.id!, entity)
          : await controller.postExternalAuthor(entity);

      if (isSuccess) {
        AppToast.success(
          isEditing ? "Cadastro atualizado!" : "Cadastro realizado!",
        );

        if (!isEditing) {
          clear();
        }
      } else {
        AppToast.error("Erro - ${controller.errorMessage.value}");
      }
    }
  }

  void clear() {
    fullNameController.clear();
    emailController.clear();
    cpfController.clear();
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      appBar: _buildAppBar(colors, theme),
      body: SharedBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.getPadding(context).left,
            vertical: 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: _buildFormCard(colors, theme),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(ColorScheme colors, ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: colors.primary,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: colors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isEditing
                  ? "Editar colaborador externo"
                  : "Formulário para cadastro de colaborador externo",
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(ColorScheme colors, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isEditing ? Icons.manage_accounts : Icons.person_add_alt_1,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing ? "Alterar dados" : "Informações Pessoais",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Preencha os campos abaixo com atenção.",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(height: 1, thickness: 1),
            ),

            CustomTextField(
              controller: fullNameController,
              label: "Nome completo",
              validator: Validators.required,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    controller: emailController,
                    label: "E-mail",
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                    prefixIcon: const Icon(Icons.alternate_email),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: CustomTextField(
                    controller: cpfController,
                    label: "CPF",
                    hintText: "000.000.000-00",
                    keyboardType: TextInputType.number,
                    inputFormatters: [InputMasks.cpf],
                    validator: Validators.cpf,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Obx(
                  () => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : _submitForm,
                  icon: controller.isLoading.value
                      ? const SizedBox.shrink()
                      : const Icon(Icons.check_circle_outline),
                  label: controller.isLoading.value
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : Text(
                    isEditing ? 'Salvar Alterações' : 'Salvar Cadastro',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}