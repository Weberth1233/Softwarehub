import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/domain/entities/external_author_entity.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/app_routes.dart';
import 'package:nit_sgpi_frontend/presentation/pages/process_external_author/controllers/process_external_author_controller.dart';
import 'dart:math' as math;
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../process/widgets/search_field_high_light.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/shared_background.dart';

class ProcessExternalAuthorPage extends StatefulWidget {
  final bool isEditMode;
  const ProcessExternalAuthorPage({super.key, this.isEditMode = false});

  @override
  State<ProcessExternalAuthorPage> createState() =>
      _ProcessExternalAuthorPageState();
}

class _ProcessExternalAuthorPageState extends State<ProcessExternalAuthorPage> {
  final externalAuthorController = Get.find<ProcessExternalAuthorController>();

  final List<ExternalAuthorEntity>? externalAuthors =
  Get.arguments is List<ExternalAuthorEntity> ? Get.arguments : null;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (externalAuthors != null && externalAuthors!.isNotEmpty) {
      externalAuthorController.externalAuthors.value = externalAuthors!;
      for (var author in externalAuthors!) {
        if (author.id != null) {
          externalAuthorController.selectedExternalAuthor[author.id!] = author;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // Barra de Pesquisa Unificada
    final Widget searchFieldWidget = SearchFieldHighlight(
      title: "Pesquise",
      icon: Icons.search,
      field: CustomTextField(
        controller: searchController,
        label: "",
        hintText: "Procure por Nome, CPF ou E-mail...",
        onChanged: (value) {
          if (value.trim().isEmpty) {
            externalAuthorController.fetchExternalAuthors();
          }
        },
        onFieldSubmitted: (_) =>
            externalAuthorController.search(searchController.text),
      ),
    );

    // FUNÇÃO DE SALVAR (Faz a exata mesma coisa que o botão voltar do AppBar)
    void handleSaveAndBack() {
      Get.back(
        result: externalAuthorController.selectedExternalAuthor,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.primary,
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
                  color: colors.onSecondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_back, color: colors.primary),
                  onPressed: handleSaveAndBack, // Usando a mesma função aqui
                  tooltip: "Voltar",
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Colaboradores externos",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.onSecondary,
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
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: UnifiedBackgroundPainter( // Trocamos o nome do Pintor
                color: theme.colorScheme.primary.withOpacity(0.08),
                icon: Icons.rocket_launch_outlined, // Adicionamos o ícone exigido
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
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth >= 1050;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Gerenciamento",
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,

                                    fontSize: 35,
                                  ),
                                ),
                              ),

                              Tooltip(
                                message: "Clique para cadastrar um novo colaborador que não possui conta no sistema",
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await Get.toNamed(AppRoutes.processExternalAuthorForm);
                                    externalAuthorController.fetchExternalAuthors(loadMore: false);
                                  },
                                  icon: const Icon(Icons.person_add_alt_1, size: 22),
                                  label: Text(
                                    "Novo Cadastro", 
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15, 
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    elevation: 3, // Leve reduzida para não gritar tanto na tela
                                    shadowColor: colors.primary.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),

                          const SizedBox(height: 40),

                          Obx(() {
                            if (externalAuthorController.isLoading.value &&
                                externalAuthorController.externalAuthors.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (externalAuthorController.errorMessage.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  externalAuthorController.errorMessage.value,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }

                            final list = externalAuthorController.externalAuthors.toList();
                            final selectedUsersList = externalAuthorController.selectedExternalAuthor.values.toList();

                            final Widget membersView = list.isEmpty
                                ? Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Sem resultados!",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                                : _MembersList(
                              controller: externalAuthorController,
                              externalAuthors: list,
                              selectedMap: externalAuthorController.selectedExternalAuthor,
                              onToggle: externalAuthorController.toggleUser,
                            );

                            final Widget paginationButtons = externalAuthorController.errorMessage.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: externalAuthorController.isLoading.value ||
                                        externalAuthorController.page.value == 0
                                        ? null
                                        : () => externalAuthorController.fetchPreviousPage(),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      side: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    child: const Text("Anterior"),
                                  ),
                                  const SizedBox(width: 24),
                                  Text(
                                    "Página ${externalAuthorController.page.value + 1}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 24),
                                  OutlinedButton(
                                    onPressed: externalAuthorController.isLoading.value ||
                                        !externalAuthorController.hasMore.value
                                        ? null
                                        : () => externalAuthorController.fetchExternalAuthors(loadMore: true),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black87,
                                      side: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    child: const Text("Próxima"),
                                  ),
                                ],
                              ),
                            )
                                : const SizedBox.shrink();

                            if (!isDesktop) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                          ),
                                          child: Text(
                                            "Cadastrados",
                                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                          child: searchFieldWidget,
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
                                    title: "Selecionados",
                                    selectedUsers: selectedUsersList,
                                    selectedIdsCount: externalAuthorController.selectedExternalAuthor.length,
                                    onRemove: externalAuthorController.removeUserById,
                                    onSave: handleSaveAndBack, // Passando a função de salvar
                                  ),
                                ],
                              );
                            }

                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                          ),
                                          child: Text(
                                            "Cadastrados",
                                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                                          child: searchFieldWidget,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: membersView,
                                        ),
                                        paginationButtons,
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                                  child: Column(
                                    children: [
                                      Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 30),
                                      Icon(Icons.chevron_left, color: Colors.grey.shade400, size: 30),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _SelectedMembersPanel(
                                        title: "Selecionados",
                                        selectedUsers: selectedUsersList,
                                        selectedIdsCount: externalAuthorController.selectedExternalAuthor.length,
                                        onRemove: externalAuthorController.removeUserById,
                                        onSave: handleSaveAndBack,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
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

class _SelectedMembersPanel extends StatelessWidget {
  final String title;
  final List<ExternalAuthorEntity> selectedUsers;
  final int selectedIdsCount;
  final void Function(int id) onRemove;
  final VoidCallback onSave; // Recebe a função de salvar

  String _safeString(String? Function() getter, {required String fallback}) {
    try {
      final value = getter();
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
      return fallback;
    } catch (_) {
      return fallback;
    }
  }

  const _SelectedMembersPanel({
    required this.title,
    required this.selectedUsers,
    required this.selectedIdsCount,
    required this.onRemove,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 480,
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "$selectedIdsCount",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: selectedUsers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final u = selectedUsers[i];
                final int id = u.id!;
                final name = _safeString(() => u.fullName, fallback: "Nome");

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                      name,style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                  subtitle: Text(
                      _safeString(() => u.email, fallback: "Email"),
                      style: TextStyle(fontSize: 12, color: Colors.black)
                  ),
                  trailing: IconButton(
                    tooltip: "Remover",
                    visualDensity: VisualDensity.compact,
                    onPressed: () => onRemove(id),
                    icon: const Icon(Icons.close_rounded, size: 25, color: Colors.redAccent),
                  ),
                );
              },
            ),
          ),
          // NOVO BOTÃO SALVAR NO RODAPÉ
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.check_circle_outline, size: 22),
              label: Text(
                "SALVAR SELEÇÃO",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                elevation: 3,
                shadowColor: colors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
  final ProcessExternalAuthorController controller;
  final List<ExternalAuthorEntity> externalAuthors;
  final Map<int, ExternalAuthorEntity> selectedMap;
  final void Function(ExternalAuthorEntity externalAuthor) onToggle;

  const _MembersList({
    required this.controller,
    required this.externalAuthors,
    required this.selectedMap,
    required this.onToggle,
  });

  String _safeString(String? Function() getter, {required String fallback}) {
    try {
      final value = getter();
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
      return fallback;
    } catch (_) {
      return fallback;
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: externalAuthors.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final externalAuthor = externalAuthors[index];
        final id = externalAuthor.id;
        final selected = id != null && selectedMap.containsKey(id);

        final fullName = _safeString(() =>externalAuthor.fullName, fallback: "Nome");
        final email = _safeString(() => externalAuthor.email, fallback: "Email");

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
              onTap: id == null ? null : () => onToggle(externalAuthor),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(Icons.person_outline, color: Colors.grey, size: 22),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await Get.toNamed(AppRoutes.processExternalAuthorForm, arguments: externalAuthor);
                            controller.fetchExternalAuthors(loadMore: false);
                          },
                          icon: const Icon(Icons.edit_outlined),
                          iconSize: 24,
                          color: colors.primary,
                          tooltip: "Editar",
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(10),
                        ),
                        IconButton(
                          onPressed: () {
                            if (id != null) {
                              controller.deleteExternalAuthor(id);
                            }
                          },
                          icon: const Icon(Icons.delete_forever),
                          iconSize: 24,
                          color: colors.error,
                          tooltip: "Excluir",
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                        Container(
                          height: 45,
                          width: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 11),
                          color: Colors.grey.shade300,
                        ),
                        Icon(
                          selected ? Icons.check_circle : Icons.add_circle_outline,
                          color: selected ? Colors.green : Colors.black54,
                          size: 28,
                        ),
                      ],
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

String _safeString(String Function() getter, {required String fallback}) {
  try {
    final v = getter();
    final s = v.toString().trim();
    return s.isEmpty ? fallback : s;
  } catch (_) {
    return fallback;
  }
}