part of '../process_detail_page.dart';

extension _ProcessDetailPageShared on _ProcessDetailPageState {
  Widget _buildSimpleCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.09)),
      ),
      child: child,
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String message,
  }) {
    final colors = Theme.of(context).colorScheme;

    return this._buildSimpleCard(
      context,
      child: Row(
        children: [
          Icon(icon, color: colors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
