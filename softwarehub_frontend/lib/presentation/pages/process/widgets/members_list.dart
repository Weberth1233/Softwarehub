import 'package:flutter/material.dart';

import '../../../../domain/entities/user/user_entity.dart';
import '../models/selected_user_entity.dart';
import '../utils/safe_string.dart';

class MembersList extends StatelessWidget {
  final List<UserEntity> users;
  final Map<int, SelectedUserEntity> selectedUsersMap;
  final void Function(UserEntity user) onToggle;

  const MembersList({
    super.key,
    required this.users,
    required this.selectedUsersMap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final u = users[index];
        final id = u.id;
        final selected = id != null && selectedUsersMap.containsKey(id);

        final fullName = safeString(() => u.fullName, fallback: "Nome");
        final email = safeString(() => u.email, fallback: "Email");

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? Colors.grey.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.grey.shade400 : Colors.grey.shade200,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              key: ValueKey(id ?? index),
              borderRadius: BorderRadius.circular(12),
              onTap: id == null ? null : () => onToggle(u),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.grey,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            fullName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      selected ? Icons.check_circle : Icons.add_circle_outline,
                      color: selected ? Colors.green : Colors.black54,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}