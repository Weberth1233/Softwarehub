
import 'package:flutter/material.dart';

class IpTypeCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color dominantColor;

  const IpTypeCard({super.key, 
    required this.title,
    required this.onTap,
    required this.dominantColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const double borderRadiusValue = 16.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          splashColor: dominantColor.withOpacity(0.06),
          highlightColor: dominantColor.withOpacity(0.03),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dominantColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.folder_special_outlined,
                    color: dominantColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D3748),
                      fontSize: 16.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
