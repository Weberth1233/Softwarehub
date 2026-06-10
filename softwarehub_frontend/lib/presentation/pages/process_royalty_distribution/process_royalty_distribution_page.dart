import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/process_royalty_distribution_controller.dart';
import 'widgets/share_form_model.dart';

class ProcessRoyaltyDistributionPage
    extends GetView<ProcessRoyaltyDistributionController> {
  const ProcessRoyaltyDistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final bool isEditMode = controller.isEditMode.value;

      return Scaffold(
        backgroundColor: colorScheme.onSecondary,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorScheme.primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          centerTitle: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 46,
                width: 46,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.arrow_back, color: colorScheme.primary),
                    onPressed: () {
                      final process = controller.process.value;

                      if (process != null) {
                        Get.back(result: process.id);
                      } else {
                        Get.back();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            isEditMode
                ? "Editar distribuição de cotas"
                : "Distribuição de cotas",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              fontSize: 20,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Obx(
                  () => _RoyaltySummaryCard(
                    processId: controller.processId,
                    processTitle: controller.processTitle,
                    totalPercentage: controller.totalPercentage,
                    remainingPercentage: controller.remainingPercentage,
                    isValid: controller.isTotalValid,
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.shares.isEmpty) {
                      return Center(
                        child: Text(
                          "Nenhuma cota encontrada.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.secondary,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: controller.shares.length,
                      itemBuilder: (context, index) {
                        final share = controller.shares[index];

                        return _ShareReadonlyCard(
                          key: ValueKey(share.id),
                          index: index,
                          share: share,
                          onSliderChanged: (value) =>
                              controller.updatePercentage(
                            index,
                            value,
                            fromText: false,
                          ),
                          onTextChanged: (value) =>
                              controller.updatePercentage(
                            index,
                            value,
                            fromText: true,
                          ),
                          onRequestUniversityChange:
                              controller.requestUniversityChange,
                        );
                      },
                    );
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.onSurface.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submit,
                        icon: controller.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(
                                isEditMode ? Icons.save_as : Icons.check,
                                color: Colors.white,
                                size: 20,
                              ),
                        label: Text(
                          controller.isLoading.value
                              ? "Salvando..."
                              : isEditMode
                                  ? "Atualizar distribuição"
                                  : "Salvar distribuição",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _RoyaltySummaryCard extends StatelessWidget {
  const _RoyaltySummaryCard({
    required this.processId,
    required this.processTitle,
    required this.totalPercentage,
    required this.remainingPercentage,
    required this.isValid,
  });

  final int processId;
  final String processTitle;
  final double totalPercentage;
  final double remainingPercentage;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color statusColor = isValid
        ? const Color(0XFF1CDF0B)
        : totalPercentage > 100
            ? Colors.red
            : Colors.orange;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primary.withOpacity(0.10),
                child: Icon(
                  Icons.pie_chart_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  processTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Processo #$processId",
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: (totalPercentage / 100).clamp(0, 1),
              minHeight: 8,
              backgroundColor: colorScheme.onSurface.withOpacity(0.3),
              color: statusColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _statusText(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${totalPercentage.toStringAsFixed(2)}%",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusText() {
    if (isValid) return "Distribuição completa";
    if (totalPercentage > 100) return "Total excedido";
    return "Restante: ${remainingPercentage.toStringAsFixed(2)}%";
  }
}

class _ShareReadonlyCard extends StatelessWidget {
  const _ShareReadonlyCard({
    super.key,
    required this.index,
    required this.share,
    required this.onSliderChanged,
    required this.onTextChanged,
    required this.onRequestUniversityChange,
  });

  final int index;
  final ShareFormModel share;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onTextChanged;
  final VoidCallback onRequestUniversityChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Obx(() {
      final isUniversity = share.type == ShareType.university;
      final isCreator = share.type == ShareType.creator;
      final typeColor = _getTypeColor(share.type, colorScheme);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colorScheme.onSurface.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: typeColor.withOpacity(0.12),
                  child: Icon(
                    _getTypeIcon(share.type),
                    size: 18,
                    color: typeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        share.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    share.type.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _PercentageField(
              value: share.percentage.value,
              controller: share.percentageController,
              enabled: !share.isLocked,
              minPercentage: share.minPercentage,
              helperText: isCreator ? "Mínimo obrigatório: 5%" : null,
              onSliderChanged: onSliderChanged,
              onTextChanged: onTextChanged,
            ),
            if (isUniversity) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.15),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "A cota da universidade é fixa em 70%.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: onRequestUniversityChange,
                        icon: Icon(
                          Icons.edit_note_outlined,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        label: Text(
                          "Solicitar alteração",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  String _subtitle() {
    switch (share.type) {
      case ShareType.university:
        return "Instituição de ensino";
      case ShareType.creator:
        return "Criador do processo";
      case ShareType.member:
        return "Autor/Membro participante";
    }
  }

  IconData _getTypeIcon(ShareType type) {
    switch (type) {
      case ShareType.university:
        return Icons.school_outlined;
      case ShareType.creator:
        return Icons.person_pin_outlined;
      case ShareType.member:
        return Icons.person_outline;
    }
  }

  Color _getTypeColor(ShareType type, ColorScheme scheme) {
    switch (type) {
      case ShareType.university:
        return scheme.primary;
      case ShareType.creator:
        return scheme.secondary;
      case ShareType.member:
        return scheme.tertiary;
    }
  }
}

class _PercentageField extends StatelessWidget {
  const _PercentageField({
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