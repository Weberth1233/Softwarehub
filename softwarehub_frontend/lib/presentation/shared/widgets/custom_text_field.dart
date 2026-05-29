import 'package:flutter/material.dart';
import 'package:nit_sgpi_frontend/presentation/shared/extensions/context_extensions.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final double? size;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool textWhiteColor;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool expands;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final void Function(String)? onChanged;

  final String? errorText;

  final int? maxLines;
  final int? minLines;

  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.size,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly = false,
    this.textWhiteColor = false,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.hintText,
    this.onChanged,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasError = errorText != null && errorText!.trim().isNotEmpty;

    Widget textField = TextFormField(
      textAlignVertical:
          expands ? TextAlignVertical.top : TextAlignVertical.center,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      expands: expands,
      maxLines: expands ? null : (obscureText ? 1 : maxLines),
      minLines: expands ? null : minLines,
      style: context.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.tertiary,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        errorText: errorText,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: theme.colorScheme.tertiary.withOpacity(0.5),
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError
                ? Colors.red
                : theme.colorScheme.tertiary.withOpacity(0.2),
            width: hasError ? 1.5 : 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: hasError ? Colors.red : theme.colorScheme.primary,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.trim().isNotEmpty) ...[
          Text(
            label,
            style: context.textTheme.bodyMedium!.copyWith(
              color: textWhiteColor
                  ? theme.colorScheme.onSecondary
                  : theme.colorScheme.tertiary,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 7),
        ],
        if (expands)
          Expanded(child: textField)
        else
          SizedBox(width: size, child: textField),
      ],
    );
  }
}