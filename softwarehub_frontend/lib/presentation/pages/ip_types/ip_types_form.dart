import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'controllers/ip_types_form_controller.dart';

class IpTypesForm extends GetView<IpTypesFormController> {
  const IpTypesForm({super.key});

  @override
  Widget build(BuildContext context) {
    final secondaryStage = controller.secondStageProcess;
    final theme = Theme.of(context);

    const primaryColor = Color(0xFF094E9A);

    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
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
                  icon: const Icon(Icons.arrow_back, color: primaryColor),
                  onPressed: () => Get.back(),
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                secondaryStage.item.name,
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
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: Colors.black.withOpacity(0.03),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 32,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preencha as informações abaixo",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                                letterSpacing: -0.1,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Insira os dados requeridos para este tipo de processo.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: controller.fields.map((field) {
                              if (!controller.isFieldVisible(field)) {
                                return const SizedBox.shrink();
                              }

                              final textController =
                                  controller.controllers[field.key]!;

                              final errorText =
                                  controller.fieldErrors[field.key];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildFieldLabel(
                                      context: context,
                                      field: field,
                                    ),
                                    const SizedBox(height: 8),
                                    _buildDynamicField(
                                      context: context,
                                      field: field,
                                      textController: textController,
                                      errorText: errorText,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: controller.submit,
                            icon: const Icon(
                              Icons.check_circle_outline,
                              size: 22,
                            ),
                            label: Text(
                              "ENVIAR INFORMAÇÕES",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              elevation: 4,
                              shadowColor: primaryColor.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
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

  Widget _buildFieldLabel({
    required BuildContext context,
    required dynamic field,
  }) {
    final theme = Theme.of(context);
    final helpText = field.helpText?.toString().trim() ?? "";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              text: field.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              children: [
                if (field.requiredField)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (helpText.isNotEmpty) ...[
          const SizedBox(width: 6),
          Tooltip(
            message: helpText,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(seconds: 6),
            waitDuration: const Duration(milliseconds: 300),
            preferBelow: false,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.35,
            ),
            child: const Icon(
              Icons.help_outline,
              size: 18,
              color: Color(0xFF094E9A),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDynamicField({
    required BuildContext context,
    required dynamic field,
    required TextEditingController textController,
    String? errorText,
  }) {
    final type = field.type.toString().toLowerCase();

    switch (type) {
      case 'textarea':
      case 'text_area':
        return SizedBox(
          height: errorText == null ? 150 : 175,
          child: CustomTextField(
            controller: textController,
            label: "",
            hintText: field.placeholder ?? "Digite aqui...",
            keyboardType: TextInputType.multiline,
            expands: true,
            errorText: errorText,
            onChanged: (value) {
              controller.updateFieldValue(field.key, value);
            },
          ),
        );

      case 'number':
        return CustomTextField(
          controller: textController,
          label: "",
          hintText: field.placeholder ?? "Digite um número...",
          keyboardType: TextInputType.number,
          errorText: errorText,
          onChanged: (value) {
            controller.updateFieldValue(field.key, value);
          },
        );

      case 'date':
        return CustomTextField(
          controller: textController,
          label: "",
          hintText: field.placeholder ?? "Selecione uma data...",
          keyboardType: TextInputType.datetime,
          readOnly: true,
          errorText: errorText,
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (selectedDate != null) {
              final formattedDate = _formatDate(selectedDate);

              controller.updateFieldValue(
                field.key,
                formattedDate,
                updateController: true,
              );
            }
          },
        );

      case 'select':
        return _buildSelectField(
          field: field,
          textController: textController,
          errorText: errorText,
        );

      case 'text':
      default:
        return CustomTextField(
          controller: textController,
          label: "",
          hintText: field.placeholder ?? "Digite aqui...",
          keyboardType: TextInputType.text,
          errorText: errorText,
          onChanged: (value) {
            controller.updateFieldValue(field.key, value);
          },
        );
    }
  }

  Widget _buildSelectField({
    required dynamic field,
    required TextEditingController textController,
    String? errorText,
  }) {
    final currentValue = textController.text.trim().isEmpty
        ? null
        : textController.text.trim();

    final options = field.options;

    return DropdownButtonFormField<String>(
      value: currentValue,
      isExpanded: true,
      dropdownColor: Colors.white,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      iconEnabledColor: Colors.black87,
      iconDisabledColor: Colors.grey,
      decoration: InputDecoration(
        hintText: field.placeholder ?? "Selecione uma opção",
        errorText: errorText,
        hintStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 15,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText == null ? Colors.grey.shade400 : Colors.red,
            width: errorText == null ? 1 : 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: errorText == null ? const Color(0xFF094E9A) : Colors.red,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
      selectedItemBuilder: (context) {
        return options.map<Widget>((option) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              option.label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();
      },
      items: options.map<DropdownMenuItem<String>>((option) {
        return DropdownMenuItem<String>(
          value: option.value,
          child: Text(
            option.label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        controller.updateFieldValue(
          field.key,
          value,
          updateController: true,
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$year-$month-$day';
  }
}

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;

  _DiagonalLinesPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

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