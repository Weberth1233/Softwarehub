import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/user/user_entity.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process/controllers/process_user_controller.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import '../../../domain/entities/external_author/external_author_entity.dart';
import '../../../domain/entities/process/process_response_entity.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'widgets/labeled_field_row.dart';
import 'widgets/search_field_high_light.dart';

class FirstStageProcess {
  final int? idProcess;
  final String title;
  final List<int> idsUser;
  final List<int> idsExternalAuthors;
  final bool isEdit;
  final String? originalIpTypeId;
  final Map<String, dynamic>? originalFormData;

  FirstStageProcess({
    this.idProcess,
    required this.title,
    required this.idsUser,
    required this.idsExternalAuthors,
    this.isEdit = false,
    this.originalIpTypeId,
    this.originalFormData,
  });
}

class ProcessPage extends StatefulWidget {
  final bool isEditMode;

  const ProcessPage({super.key, this.isEditMode = false});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  final ProcessResponseEntity? process = Get.arguments is ProcessResponseEntity
      ? Get.arguments
      : null;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchEmaiController = TextEditingController();
  final TextEditingController searchCpfController = TextEditingController();

  List<int> idsExternalAuthors = [];
  List<ExternalAuthorEntity> listExternalAuthor = [];

  final userController = Get.find<ProcessUserController>();
  Worker? _usersWorker;

  @override
  void initState() {
    super.initState();
    if (process != null) {
      titleController.text = process!.title;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final userController = Get.find<ProcessUserController>();
        final Set<int> pendingIds = process!.authors
            .map((u) => u.id)
            .whereType<int>()
            .toSet();

        _usersWorker = ever(userController.users, (
          List<UserEntity> loadedUsers,
        ) {
          if (pendingIds.isEmpty) return;

          for (var user in loadedUsers) {
            if (pendingIds.contains(user.id)) {
              userController.selectedUsers[user.id!] = user;
              pendingIds.remove(user.id);
            }
          }
        });

        if (userController.users.isEmpty) {
          userController.fetchUsers();
        }

        listExternalAuthor = process!.externalAuthors;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    searchController.dispose();
    searchEmaiController.dispose();
    searchCpfController.dispose();
    _usersWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<ProcessUserController>();
    final theme = Theme.of(context);

    // FUNÇÃO CALLBACK: passada para o painel de autores externos
    void handleManageExternals() async {
      var result = await Get.toNamed(
        "/process/process-external-author",
        arguments: listExternalAuthor,
      );
      if (result != null && result is Map<int, ExternalAuthorEntity>) {
        setState(() {
          listExternalAuthor = result.values.toList();
          idsExternalAuthors = result.keys.toList();
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ThemeColor.primaryColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 74,
        titleSpacing: 12,
        title: Row(
          children: [
            SizedBox(
              height: 46,
              width: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: Colors.grey.shade900),
                  onPressed: () => Get.back(),
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.isEditMode ? "Editar Processo" : "Cadastro de Processo",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFCBD5E1),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DiagonalLinesPainter(
                color: Colors.black.withOpacity(0.03),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              Responsive.getPadding(context).left,
              20,
              Responsive.getPadding(context).right,
              24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade300),
                  ),

                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 1050;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isEditMode
                                    ? "Editar seu Processo"
                                    : "Cadastre seu Processo",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87,
                                  letterSpacing: -0.1,
                                  fontSize: 35,
                                ),
                              ),
                              Text(
                                widget.isEditMode
                                    ? "Insira as informações necessárias para atualizar seu processo no sistema."
                                    : "Insira as informações necessárias para cadastrar seu processo no sistema.",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  "Título da API:",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  controller: titleController,
                                  label: "",
                                  hintText:
                                      "Ex: Registro de Patente de Software",
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 45),

                          Obx(() {
                            if (userController.isLoading.value &&
                                userController.users.isEmpty) {
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
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
                            final selectedUsersList = userController
                                .selectedUsers
                                .values
                                .toList();

                            final Widget membersView = list.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Sem resultados!",
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  )
                                : _MembersList(
                                    users: list,
                                    selectedUsersMap:
                                        userController.selectedUsers,
                                    onToggle: userController.toggleUser,
                                  );

                            final Widget paginationButtons =
                                userController.errorMessage.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed:
                                              userController.isLoading.value ||
                                                  userController.page.value == 0
                                              ? null
                                              : () => userController
                                                    .fetchPreviousPage(),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.black87,
                                            side: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          child: Text(
                                            "Anterior",
                                            style: TextStyle(
                                              color: ThemeColor.primaryColor
                                                  .withOpacity(0.5),
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
                                          onPressed:
                                              userController.isLoading.value ||
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
                                              color: ThemeColor.primaryColor
                                                  .withOpacity(0.5),
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
                                    constr.maxWidth > 500 &&
                                    constr.maxWidth <= 850;

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
                                          onFieldSubmitted: (_) => userController
                                              .searchByFilter(searchController.text),
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
                                          icon: const Icon(Icons.search, color: Colors.white),
                                          iconSize: 25,
                                          tooltip: "Buscar",
                                          onPressed: () {
                                            userController.searchByFilter(searchController.text);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (isDesktopSearch) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 5, child: filter),
                                      const SizedBox(width: 16),
                                    ],
                                  );
                                } else if (isTabletSearch) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      filter,
                                      const SizedBox(height: 10),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                }
                              },
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
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Colaboradores disponíveis",
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                            12,
                                            12,
                                            12,
                                            0,
                                          ),
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

                                  const SizedBox(height: 16),
                                  _SelectedMembersPanel(
                                    title: "Colaboradores selecionados",
                                    selectedUsers: selectedUsersList,
                                    selectedIdsCount:
                                        userController.selectedUsers.length,
                                    onRemove: userController.removeUserById,
                                  ),
                                  const SizedBox(height: 10),

                                  _SelectedMembersExternalPanel(
                                    title:
                                        "Colaboradores externos selecionados",
                                    externalAuthors: listExternalAuthor,
                                    onManage: handleManageExternals,
                                  ),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade50,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey.shade200,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                "Adicione pelo menos um colaborador ao processo",
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                  color: Colors.redAccent,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    12,
                                                    12,
                                                    12,
                                                    0,
                                                  ),
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
                                      _SelectedMembersPanel(
                                        title: "Selecionados",
                                        selectedUsers: selectedUsersList,
                                        selectedIdsCount:
                                            userController.selectedUsers.length,
                                        onRemove: userController.removeUserById,
                                      ),
                                      const SizedBox(height: 16),

                                      _SelectedMembersExternalPanel(
                                        title:
                                            "Colaboradores externos selecionados",
                                        externalAuthors: listExternalAuthor,
                                        onManage: handleManageExternals,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),

                          const SizedBox(height: 26),

                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 220,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (titleController.text.trim().isEmpty ||
                                      (userController.selectedUsers.isEmpty &&
                                          listExternalAuthor.isEmpty)) {
                                    Get.snackbar(
                                      "Campos inválidos!",
                                      "Necessário inserir os campos abaixo para prosseguir...",
                                      backgroundColor: Colors.grey.shade800,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  final auxProcess = FirstStageProcess(
                                    idProcess: process?.id,
                                    title: titleController.text.trim(),
                                    idsUser: userController.selectedUsers.keys
                                        .toList(),
                                    idsExternalAuthors: idsExternalAuthors,
                                    isEdit: widget.isEditMode,
                                    originalIpTypeId: process?.ipType.id
                                        .toString(),
                                    originalFormData: process?.formData,
                                  );
                                  await Get.toNamed(
                                    "/process/ip_types",
                                    arguments: auxProcess,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColor.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Próximo",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MembersList extends StatelessWidget {
  final List<UserEntity> users;
  final Map<int, UserEntity> selectedUsersMap;
  final void Function(UserEntity user) onToggle;

  const _MembersList({
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

        final fullName = _safeString(() => u.fullName, fallback: "Nome");
        final email = _safeString(() => u.email, fallback: "Email");

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

class _SelectedMembersPanel extends StatelessWidget {
  final String title;
  final List<UserEntity> selectedUsers;
  final int selectedIdsCount;
  final void Function(int id) onRemove;

  const _SelectedMembersPanel({
    required this.title,
    required this.selectedUsers,
    required this.selectedIdsCount,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$selectedIdsCount",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: selectedIdsCount == 0
                ? Center(
                    child: Text(
                      "Nenhum selecionado",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: selectedUsers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final u = selectedUsers[i];
                      final int id = u.id!;
                      final name = _safeString(
                        () => u.fullName,
                        fallback: "Nome",
                      );

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          _safeString(() => u.email, fallback: "Email"),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: IconButton(
                          tooltip: "Remover",
                          visualDensity: VisualDensity.compact,
                          onPressed: () => onRemove(id),
                          icon: Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SelectedMembersExternalPanel extends StatelessWidget {
  final String title;
  final List<ExternalAuthorEntity> externalAuthors;
  final VoidCallback onManage;

  const _SelectedMembersExternalPanel({
    required this.title,
    required this.externalAuthors,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${externalAuthors.length}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: externalAuthors.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum selecionado",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: externalAuthors.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final u = externalAuthors[i];
                      final name = _safeString(
                        () => u.fullName,
                        fallback: "Nome",
                      );

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Botão no rodapé do bloco de colaboradores externos
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ElevatedButton.icon(
              onPressed: onManage,
              icon: const Icon(Icons.settings, size: 20),
              label: Text(
                "Gerenciar colaboradores externos",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeColor.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                elevation: 3,
                shadowColor: ThemeColor.primaryColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _safeString(String? Function() getter, {required String fallback}) {
  try {
    final v = getter();
    if (v == null) return fallback;
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  } catch (_) {
    return fallback;
  }
}

class _DiagonalLinesPainter extends CustomPainter {
  final Color color;

  _DiagonalLinesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const spacing = 80.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
