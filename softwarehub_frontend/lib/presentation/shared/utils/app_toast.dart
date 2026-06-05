import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppToastType { success, error, warning, info }

class AppToast {
  static OverlayEntry? _currentToast;

  static void success(String message) {
    _show(title: 'Sucesso', message: message, type: AppToastType.success);
  }

  static void error(String message) {
    _show(title: 'Erro', message: message, type: AppToastType.error);
  }

  static void warning(String message) {
    _show(title: 'Atenção', message: message, type: AppToastType.warning);
  }

  static void info(String message) {
    _show(title: 'Informação', message: message, type: AppToastType.info);
  }

  static void _show({
    required String title,
    required String message,
    required AppToastType type,
  }) {
    final overlay = Get.key.currentState?.overlay;

    if (overlay == null) {
      debugPrint('AppToast: Overlay não encontrado.');
      return;
    }

    _currentToast?.remove();
    _currentToast = null;

    final duration = const Duration(seconds: 4);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return _AppToastWidget(
          title: title,
          message: message,
          type: type,
          duration: duration,
          onClose: () {
            if (entry.mounted) {
              entry.remove();
            }

            if (_currentToast == entry) {
              _currentToast = null;
            }
          },
        );
      },
    );

    _currentToast = entry;
    overlay.insert(entry);

    Future.delayed(duration, () {
      if (_currentToast == entry && entry.mounted) {
        entry.remove();
        _currentToast = null;
      }
    });
  }
}

class _AppToastWidget extends StatelessWidget {
  final String title;
  final String message;
  final AppToastType type;
  final Duration duration;
  final VoidCallback onClose;

  const _AppToastWidget({
    required this.title,
    required this.message,
    required this.type,
    required this.duration,
    required this.onClose,
  });

  Color get color {
    switch (type) {
      case AppToastType.success:
        return Colors.green;
      case AppToastType.error:
        return Colors.red;
      case AppToastType.warning:
        return Colors.orange;
      case AppToastType.info:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (type) {
      case AppToastType.success:
        return Icons.check_circle_outline;
      case AppToastType.error:
        return Icons.error_outline;
      case AppToastType.warning:
        return Icons.warning_amber_rounded;
      case AppToastType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final toastWidth = screenWidth < 600 ? screenWidth - 32 : 460.0;

    return Positioned(
      top: 24,
      right: 16,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(40 * (1 - value), 0),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              width: toastWidth,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 10, 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  title,
                                  style: Get.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message,
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onClose,
                            icon: const Icon(Icons.close),
                            iconSize: 20,
                            splashRadius: 20,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ],
                      ),
                    ),

                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 1, end: 0),
                      duration: duration,
                      curve: Curves.linear,
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 4,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.9),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
