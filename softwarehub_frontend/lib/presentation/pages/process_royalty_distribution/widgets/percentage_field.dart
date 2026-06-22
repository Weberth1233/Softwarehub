
import 'package:flutter/material.dart';

class PercentageField extends StatelessWidget {
  const PercentageField({super.key, 
    required this.value,
    required this.controller,
    required this.onSliderChanged,
    required this.onTextChanged,
    this.enabled = true,
    this.minPercentage = 0,
    this.helperText,
  });

  final double value;
  final TextEditingController controller;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onTextChanged;
  final bool enabled;
  final double minPercentage;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Porcentagem da cota",
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.tertiary,
              ),
            ),
            if (helperText != null)
              Text(
                helperText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (enabled)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: colorScheme.primary,
                  size: 24,
                ),
                onPressed: () {
                  final newValue = value - 1.0;
                  if (newValue >= minPercentage) {
                    onSliderChanged(newValue);
                  }
                },
              ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: colorScheme.primary,
                  inactiveTrackColor: colorScheme.onSurface.withOpacity(0.3),
                  thumbColor: colorScheme.primary,
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 7,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 14,
                  ),
                ),
                child: Slider(
                  value: value.clamp(minPercentage, 100),
                  min: minPercentage,
                  max: 100,
                  divisions: 100,
                  onChanged: enabled ? onSliderChanged : null,
                ),
              ),
            ),
            if (enabled)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.primary,
                  size: 24,
                ),
                onPressed: () {
                  final newValue = value + 1.0;
                  if (newValue <= 100.0) {
                    onSliderChanged(newValue);
                  }
                },
              ),
            const SizedBox(width: 8),
            Container(
              width: 85,
              height: 36,
              decoration: BoxDecoration(
                color: enabled
                    ? Colors.white
                    : colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: enabled
                      ? colorScheme.onSurface.withOpacity(0.4)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: enabled,
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: enabled
                            ? colorScheme.tertiary
                            : colorScheme.secondary,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (text) {
                        final percentage = double.tryParse(
                          text.replaceAll(",", "."),
                        );

                        if (percentage == null) return;

                        onTextChanged(percentage);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "%",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: enabled
                            ? colorScheme.tertiary
                            : colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
