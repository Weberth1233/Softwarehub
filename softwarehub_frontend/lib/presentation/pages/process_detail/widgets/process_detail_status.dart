part of '../process_detail_page.dart';

extension _ProcessDetailPageStatus on _ProcessDetailPageState {
  Widget _buildProcessStatusBar(
    BuildContext context,
    ProcessResponseEntity entity,
    String date,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final title = entity.title.isNotEmpty ? entity.title : entity.ipType.name;
    final statusUI = this._statusUi(context, entity.status);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 25 : 16,
        vertical: isDesktop ? 25 : 16,
      ),
      decoration: BoxDecoration(
        color: colors.onSecondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 50,
            decoration: BoxDecoration(
              color: statusUI.color,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: isDesktop ? 25 : 18,
                    fontWeight: FontWeight.w900,
                    color: colors.tertiary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "ID #${entity.id} • $date",
                  style: TextStyle(fontSize: 13, color: colors.secondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 15 : 10,
              vertical: isDesktop ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: statusUI.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusUI.icon, size: 14, color: statusUI.color),
                if (isDesktop) const SizedBox(width: 6),
                if (isDesktop)
                  Text(
                    statusUI.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: statusUI.color,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusUi _statusUi(BuildContext context, String status) {
    final colors = Theme.of(context).colorScheme;

    Color color;
    IconData icon;
    String label = status.replaceAll('_', ' ').toUpperCase();

    switch (status) {
      case 'EM_ANDAMENTO':
        color = Colors.orange;
        icon = Icons.hourglass_top_rounded;
        break;
      case 'FINALIZADO':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'CORRECAO':
        color = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      default:
        color = colors.secondary;
        icon = Icons.info_outline;
    }

    return _StatusUi(color: color, icon: icon, label: label);
  }
}
