import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/entities/external_author/external_author_entity.dart';
import '../../../domain/entities/process/process_response_entity.dart';
import '../../core/routes/app_routes.dart';
import '../../shared/theme/theme_color.dart';
import '../../shared/utils/app_toast.dart';
import '../../shared/utils/responsive.dart';
import '../../shared/widgets/diagonal_lines_painter.dart';
import 'controllers/process_user_controller.dart';
import 'models/first_stage_process.dart';
import 'widgets/collaborators_section.dart';
import 'widgets/process_app_bar.dart';
import 'widgets/process_page_header.dart';
import 'widgets/process_title_field.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  final ProcessResponseEntity? process = Get.arguments is ProcessResponseEntity
      ? Get.arguments
      : null;

  bool isEditMode = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchEmaiController = TextEditingController();
  final TextEditingController searchCpfController = TextEditingController();

  List<int> idsExternalAuthors = [];
  List<ExternalAuthorEntity> listExternalAuthor = [];

  final userController = Get.find<ProcessUserController>();
  Worker? _usersWorker;

  bool _showValidationErrors = false;

  String? get _titleError {
    if (!_showValidationErrors) return null;
    if (titleController.text.trim().isEmpty) {
      return "O título é obrigatório";
    }
    return null;
  }

  bool get _hasCollaboratorError {
    if (!_showValidationErrors) return false;
    return userController.selectedUsers.isEmpty && listExternalAuthor.isEmpty;
  }

  @override
  void initState() {
    super.initState();

    isEditMode = process != null;

    titleController.addListener(() {
      if (_showValidationErrors) setState(() {});
    });

    if (process != null) {
      titleController.text = process!.title;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        userController.setInitialSelectedProcessAuthors(process!.authors);

        setState(() {
          listExternalAuthor = process!.externalAuthors;
          idsExternalAuthors = process!.externalAuthors
              .map((author) => author.id)
              .whereType<int>()
              .toList();
        });

        if (userController.users.isEmpty) {
          userController.fetchUsers();
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userController.clearSelectedUsers();

        if (userController.users.isEmpty) {
          userController.fetchUsers();
        }
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

  Future<void> _handleNext() async {
    final isTitleEmpty = titleController.text.trim().isEmpty;

    final hasNoCollaborators =
        userController.selectedUsers.isEmpty && listExternalAuthor.isEmpty;

    if (isTitleEmpty || hasNoCollaborators) {
      setState(() => _showValidationErrors = true);

      AppToast.warning(
        "Campos inválidos! - Necessário inserir os campos abaixo para prosseguir...",
      );

      return;
    }

    final activeRoyaltyDistributions =
        process?.royaltyDistributions
            .where((distribution) => distribution.status == "ACTIVE")
            .toList() ??
        [];

    final activeRoyaltyDistribution = activeRoyaltyDistributions.isNotEmpty
        ? activeRoyaltyDistributions.first
        : null;

    final auxProcess = FirstStageProcess(
      idProcess: process?.id,
      title: titleController.text.trim(),
      idsUser: userController.selectedUsers.keys.toList(),
      idsExternalAuthors: idsExternalAuthors,
      isEdit: isEditMode,
      originalIpTypeId: process?.ipType.id.toString(),
      originalFormData: process?.formData,
      activeRoyaltyDistribution: activeRoyaltyDistribution,
    );

    await Get.toNamed(AppRoutes.ipTypes, arguments: auxProcess);
  }

  void _handleManageExternals() async {
    var result = await Get.toNamed(
      AppRoutes.processExternalAuthor,
      arguments: listExternalAuthor,
    );

    if (result != null && result is Map<int, ExternalAuthorEntity>) {
      setState(() {
        listExternalAuthor = result.values.toList();
        idsExternalAuthors = result.keys.toList();

        if (_showValidationErrors) _showValidationErrors = true;
      });
    }
  }

  void _handleUserChanged() {
    if (_showValidationErrors) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProcessAppBar(isEditMode: isEditMode),
      backgroundColor: const Color(0xFFCBD5E1),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalLinesPainter(
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
                          ProcessPageHeader(isEditMode: isEditMode),

                          const SizedBox(height: 30),

                          ProcessTitleField(
                            controller: titleController,
                            errorText: _titleError,
                          ),

                          const SizedBox(height: 45),

                          CollaboratorsSection(
                            isDesktop: isDesktop,
                            userController: userController,
                            searchController: searchController,
                            externalAuthors: listExternalAuthor,
                            hasCollaboratorError: _hasCollaboratorError,
                            onUserChanged: _handleUserChanged,
                            onManageExternals: _handleManageExternals,
                          ),

                          const SizedBox(height: 26),

                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 220,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: _handleNext,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColor.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "Próximo",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
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