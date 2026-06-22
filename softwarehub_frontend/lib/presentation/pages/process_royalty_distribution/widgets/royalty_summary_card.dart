
import 'package:flutter/material.dart';

class RoyaltySummaryCard extends StatelessWidget {
  const RoyaltySummaryCard({super.key, 
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