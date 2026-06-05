import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../domain/entities/process/process_user_entity.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../shared/utils/app_toast.dart';
import '../widgets/share_form_model.dart';

class ProcessRoyaltyDistributionController extends GetxController {
  final GetProcessById _getProcessById;

  ProcessRoyaltyDistributionController(this._getProcessById);

  final formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;

  final Rxn<ProcessResponseEntity> process = Rxn<ProcessResponseEntity>();

  final RxList<ShareFormModel> shares = <ShareFormModel>[].obs;

  static const int unitinsId = 2;
  static const String unitinsName = "Universidade Estadual do Tocantins";

  static const double universityFixedPercentage = 70.0;
  static const double creatorMinimumPercentage = 5.0;

  int get processId => process.value?.id ?? 0;

  String get processTitle => process.value?.title ?? "Carregando processo...";

  int? get changeRequestId => null;

  double get totalPercentage {
    return shares.fold(
      0.0,
      (sum, item) => sum + item.percentage.value,
    );
  }

  double get remainingPercentage {
    return 100 - totalPercentage;
  }

  bool get isTotalValid {
    return totalPercentage.toStringAsFixed(2) == "100.00";
  }

  ShareFormModel? get creatorShare {
    return shares.firstWhereOrNull(
      (item) => item.type == ShareType.creator,
    );
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    final id = args?['processId'] as int?;

    if (id == null) {
      AppToast.error("ID do processo não informado.");
      Get.back();
      return;
    }

    getProcessById(id);
  }

  Future<void> getProcessById(int id) async {
    try {
      isLoading.value = true;

      final result = await _getProcessById(id);

      result.fold(
        (failure) {
          AppToast.error("Erro ao buscar processo.");
          Get.back();
        },
        (success) {
          process.value = success;
          _buildSharesFromProcess(success);
        },
      );
    } catch (e) {
      AppToast.error("Erro inesperado ao buscar processo.");
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void _buildSharesFromProcess(ProcessResponseEntity process) {
    shares.clear();

    final creator = process.creator;

    final members = process.authors.where((author) {
      return author.id != creator.id;
    }).toList();

    final availableForMembers =
        100 - universityFixedPercentage - creatorMinimumPercentage;

    final memberPercentages = _distributePercentage(
      total: availableForMembers,
      quantity: members.length,
    );

    shares.add(
      ShareFormModel(
        type: ShareType.university,
        displayName: unitinsName,
        educationalInstitutionId: unitinsId,
        percentage: universityFixedPercentage.obs,
        isLocked: true,
      ),
    );

    shares.add(
      ShareFormModel(
        type: ShareType.creator,
        displayName: _getUserName(creator),
        userId: creator.id,
        percentage: creatorMinimumPercentage.obs,
        minPercentage: creatorMinimumPercentage,
      ),
    );

    for (int i = 0; i < members.length; i++) {
      final member = members[i];

      shares.add(
        ShareFormModel(
          type: ShareType.member,
          displayName: _getUserName(member),
          userId: member.id,
          percentage: memberPercentages[i].obs,
        ),
      );
    }

    _syncControllers();
    shares.refresh();
  }

  List<double> _distributePercentage({
    required double total,
    required int quantity,
  }) {
    if (quantity <= 0) {
      return [];
    }

    final base = double.parse((total / quantity).toStringAsFixed(2));

    final values = List<double>.filled(quantity, base);

    final currentTotal = values.fold(
      0.0,
      (sum, value) => sum + value,
    );

    final difference = double.parse(
      (total - currentTotal).toStringAsFixed(2),
    );

    values[quantity - 1] = double.parse(
      (values.last + difference).toStringAsFixed(2),
    );

    return values;
  }

  String _getUserName(ProcessUserEntity user) {
    if (user.fullName.trim().isNotEmpty) {
      return user.fullName;
    }

    if ((user.email ?? '').trim().isNotEmpty) {
      return user.email!;
    }

    return "Usuário #${user.id}";
  }

  void updatePercentage(int index, double value) {
    final share = shares[index];

    if (share.isLocked) {
      AppToast.warning("A cota da universidade é fixa em 70%.");
      return;
    }

    if (share.type == ShareType.creator &&
        value < creatorMinimumPercentage) {
      value = creatorMinimumPercentage;

      AppToast.warning(
        "O criador não pode ter menos de ${creatorMinimumPercentage.toStringAsFixed(0)}%.",
      );
    }

    final normalized = double.parse(value.toStringAsFixed(2));

    share.percentage.value = normalized;
    share.percentageController.text = normalized.toStringAsFixed(2);

    shares.refresh();
  }

  void requestUniversityChange() {
    AppToast.warning(
      "Para alterar a cota da universidade é necessário solicitar uma alteração.",
    );

    // Quando tiver a tela de solicitação:
    //
    // Get.toNamed(
    //   '/royalty-change-request',
    //   arguments: {
    //     'processId': processId,
    //     'currentPercentage': universityFixedPercentage,
    //   },
    // );
  }

  bool validate() {
    if (shares.isEmpty) {
      AppToast.warning("Nenhuma cota encontrada.");
      return false;
    }

    final creator = creatorShare;

    if (creator == null) {
      AppToast.warning("Criador não encontrado na distribuição.");
      return false;
    }

    if (creator.percentage.value < creatorMinimumPercentage) {
      AppToast.warning(
        "O criador precisa ter pelo menos ${creatorMinimumPercentage.toStringAsFixed(0)}%.",
      );
      return false;
    }

    if (!isTotalValid) {
      AppToast.warning(
        "A soma das cotas precisa ser 100%. Atual: ${totalPercentage.toStringAsFixed(2)}%",
      );
      return false;
    }

    return true;
  }

  Map<String, dynamic> buildJson() {
    return {
      "processId": processId,
      "changeRequestId": changeRequestId,
      "shares": shares.map((share) => share.toJson()).toList(),
    };
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!validate()) return;

    final json = buildJson();

    debugPrint(json.toString());

    AppToast.success("Distribuição de cotas criada com sucesso!");

    // Aqui depois você chama seu usecase de salvar distribuição.
    //
    // await _createRoyaltyDistribution(
    //   ProcessRoyaltyDistributionRequestEntity.fromJson(json),
    // );
  }

  void _syncControllers() {
    for (final share in shares) {
      share.percentageController.text =
          share.percentage.value.toStringAsFixed(2);
    }
  }

  @override
  void onClose() {
    for (final share in shares) {
      share.dispose();
    }

    super.onClose();
  }
}