import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/external_author_entity.dart';
import '../../../shared/theme/theme_color.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/process_user_controller.dart';
import 'members_list.dart';
import 'search_field_high_light.dart';
import 'selected_external_members_panel.dart';
import 'selected_members_panel.dart';

class CollaboratorsSection extends StatelessWidget {
  final bool isDesktop;
  final ProcessUserController userController;
  final TextEditingController searchController;
  final List<ExternalAuthorEntity> externalAuthors;
  final bool hasCollaboratorError;
  final VoidCallback onUserChanged;
  final VoidCallback onManageExternals;

  const CollaboratorsSection({
    super.key,
    required this.isDesktop,
    required this.userController,
    required this.searchController,
    required this.externalAuthors,
    required this.hasCollaboratorError,
    required this.onUserChanged,
    required this.onManageExternals,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (userController.isLoading.value && userController.users.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ),
        );
      }

      if (userController.errorMessage.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            userController.errorMessage.value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.red.shade800,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }

      final list = userController.users.toList();
      final selectedUsersList = userController.selectedUsers.values.toList();

      final Widget membersView = list.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      "Sem resultados!",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          : MembersList(
              users: list,
              selectedUsersMap: userController.selectedUsers,
              onToggle: (user) {
                userController.toggleUser(user);

                onUserChanged();
              },
            );

      final Widget paginationButtons = userController.errorMessage.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: userController.isLoading.value ||
                            userController.page.value == 0
                        ? null
                        : () => userController.fetchPreviousPage(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(
                      "Anterior",
                      style: TextStyle(
                        color: ThemeColor.primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    "Página ${userController.page.value + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 24),
                  OutlinedButton(
                    onPressed: userController.isLoading.value ||
                            !userController.hasMore.value
                        ? null
                        : () => userController.fetchUsers(
                              loadMore: true,
                            ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(
                      "Próxima",
                      style: TextStyle(
                        color: ThemeColor.primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();

      final Widget searchAuthorWidget = LayoutBuilder(
        builder: (context, constr) {
          final isDesktopSearch = constr.maxWidth > 850;
          final isTabletSearch =
              constr.maxWidth > 500 && constr.maxWidth <= 850;

          void onSearchChanged(String value) {
            if (value.trim().isEmpty) {
              userController.fetchUsers();
            }
          }

          final filter = SearchFieldHighlight(
            title: "Pesquise por colaboradores",
            icon: Icons.people_alt,
            field: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: searchController,
                    label: "",
                    hintText: "Procure por Nome, CPF ou email",
                    onChanged: onSearchChanged,
                    onFieldSubmitted: (_) => userController.searchByFilter(
                      searchController.text,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 47,
                  height: 42,
                  decoration: BoxDecoration(
                    color: ThemeColor.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    iconSize: 25,
                    tooltip: "Buscar",
                    onPressed: () {
                      userController.searchByFilter(
                        searchController.text,
                      );
                    },
                  ),
                ),
              ],
            ),
          );

          if (isDesktopSearch) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: filter),
                const SizedBox(width: 16),
              ],
            );
          } else if (isTabletSearch) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: filter),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                filter,
                const SizedBox(height: 10),
                const SizedBox(height: 10),
              ],
            );
          }
        },
      );

      final collaboratorPanelHeader = Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: hasCollaboratorError
              ? Colors.red.shade50
              : Colors.grey.shade50,
          border: Border(
            bottom: BorderSide(
              color: hasCollaboratorError
                  ? Colors.red.shade200
                  : Colors.grey.shade200,
            ),
          ),
        ),
        child: Text(
          "Adicione pelo menos um colaborador ao processo",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: hasCollaboratorError
                ? Colors.red.shade700
                : Colors.redAccent,
          ),
        ),
      );

      if (!isDesktop) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasCollaboratorError
                      ? Colors.red.shade400
                      : Colors.grey.shade300,
                  width: hasCollaboratorError ? 1.5 : 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  collaboratorPanelHeader,
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: searchAuthorWidget,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: membersView,
                  ),
                  paginationButtons,
                ],
              ),
            ),
            if (hasCollaboratorError)
              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                  left: 4,
                ),
                child: Text(
                  "Selecione ao menos um colaborador",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SelectedMembersPanel(
              title: "Colaboradores selecionados",
              selectedUsers: selectedUsersList,
              selectedIdsCount: userController.selectedUsers.length,
              onRemove: (id) {
                userController.removeUserById(id);

                onUserChanged();
              },
            ),
            const SizedBox(height: 10),
            SelectedMembersExternalPanel(
              title: "Colaboradores externos selecionados",
              externalAuthors: externalAuthors,
              onManage: onManageExternals,
            ),
          ],
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: hasCollaboratorError
                          ? Colors.red.shade400
                          : Colors.grey.shade300,
                      width: hasCollaboratorError ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      collaboratorPanelHeader,
                      Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                        child: searchAuthorWidget,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: membersView,
                      ),
                      paginationButtons,
                    ],
                  ),
                ),
                if (hasCollaboratorError)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 6,
                      left: 4,
                    ),
                    child: Text(
                      "Selecione ao menos um colaborador",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 40,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 30,
                ),
                Icon(
                  Icons.chevron_left,
                  color: Colors.grey.shade400,
                  size: 30,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SelectedMembersPanel(
                  title: "Selecionados",
                  selectedUsers: selectedUsersList,
                  selectedIdsCount: userController.selectedUsers.length,
                  onRemove: (id) {
                    userController.removeUserById(id);

                    onUserChanged();
                  },
                ),
                const SizedBox(height: 16),
                SelectedMembersExternalPanel(
                  title: "Colaboradores externos selecionados",
                  externalAuthors: externalAuthors,
                  onManage: onManageExternals,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}