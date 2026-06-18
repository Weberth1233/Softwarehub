import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/core/routes/app_routes.dart';
import '../../../../domain/entities/external_author/external_author_entity.dart';
import '../../../../domain/entities/process/process_response_entity.dart';
import '../../../../domain/entities/process/process_royalty_distribution_request_entity.dart';
import '../../../../domain/entities/process/process_user_entity.dart';
import '../../../../domain/usecases/process/get_process_by_id.dart';
import '../../../../domain/usecases/process_royalty_distribution/post_process_royalty_distribution.dart';
import '../../../../domain/usecases/process_royalty_distribution/put_process_royalty_distribution.dart';
import '../../../../infra/models/process/process_royalty_distribution_request_model.dart';
import '../../../shared/utils/app_toast.dart';
import '../widgets/share_form_model.dart';

class ProcessRoyaltyDistributionController extends GetxController {
  final GetProcessById _getProcessById;
  final PostProcessRoyaltyDistribution _postRoyaltyDistribution;
  final PutProcessRoyaltyDistribution _putRoyaltyDistribution;

  ProcessRoyaltyDistributionController(
    this._getProcessById,
    this._postRoyaltyDistribution,
    this._putRoyaltyDistribution,
  );

  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;
  final Rxn<ProcessResponseEntity> process = Rxn<ProcessResponseEntity>();

  final RxBool openedFromProcessFlow = false.obs;

  bool isEdit = false;

  final RxBool isEditMode = false.obs;
  final RxnInt distributionId = RxnInt();

  final RxList<ShareFormModel> shares = <ShareFormModel>[].obs;

  static const int unitinsId = 2;
  static const String unitinsName = "Universidade Estadual do Tocantins";
  static const double universityFixedPercentage = 70.0;
  static const double creatorMinimumPercentage = 5.0;

  int get processId => process.value?.id ?? 0;
  String get processTitle => process.value?.title ?? "Carregando processo...";
  int? get changeRequestId => null;

  double get totalPercentage {
    return shares.fold(0.0, (sum, item) => sum + item.percentage.value);
  }

  double get remainingPercentage {
    return 100.0 - totalPercentage;
  }

  bool get isTotalValid {
    return totalPercentage.toStringAsFixed(2) == "100.00";
  }

  ShareFormModel? get creatorShare {
    return shares.firstWhereOrNull((item) => item.type == ShareType.creator);
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      final receivedDistributionId = args['distributionId'];

      if (receivedDistributionId is int) {
        distributionId.value = receivedDistributionId;
        isEditMode.value = true;
      } else if (receivedDistributionId is String) {
        distributionId.value = int.tryParse(receivedDistributionId);
        isEditMode.value = distributionId.value != null;
      }

      openedFromProcessFlow.value = args['openedFromProcessFlow'] == true;
      isEdit = args['editProcess'] == true;
    }

    _loadProcessFromRoute();
  }

  void _loadProcessFromRoute() {
    final idStr = Get.parameters['id'];

    final idFromUrl = int.tryParse(idStr ?? '');

    final args = Get.arguments;

    int? idFromArgs;

    if (args is Map<String, dynamic>) {
      final value = args['processId'];

      if (value is int) {
        idFromArgs = value;
      } else if (value is String) {
        idFromArgs = int.tryParse(value);
      }
    }

    final id = idFromUrl ?? idFromArgs;

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
      process.value = null;
      shares.clear();
      final result = await _getProcessById(id);
      result.fold(
        (failure) {
          AppToast.error("Erro ao buscar processo.");
          Get.back();
        },
        (success) {
          process.value = success;
          try {
            _buildSharesFromProcess(success);
            if (isEditMode.value && distributionId.value != null) {
              _applySavedRoyaltyDistribution(success);
            }
          } catch (e) {
            AppToast.error("Erro ao montar distribuição de cotas.");
          }
        },
      );
    } catch (e) {
      AppToast.error("Erro inesperado ao buscar processo.");
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void _applySavedRoyaltyDistribution(ProcessResponseEntity process) {
    final id = distributionId.value;

    if (id == null) return;

    final distribution = process.royaltyDistributions.firstWhereOrNull(
      (distribution) => distribution.id == id,
    );

    if (distribution == null) {
      AppToast.error("Distribuição de cotas não encontrada para edição.");
      return;
    }

    for (final formShare in shares) {
      final savedShare = distribution.shares.firstWhereOrNull((saved) {
        final sameUser =
            formShare.userId != null &&
            saved.userId != null &&
            saved.userId == formShare.userId;

        final sameExternalAuthor =
            formShare.externalAuthorId != null &&
            saved.externalAuthorId != null &&
            saved.externalAuthorId == formShare.externalAuthorId;

        final sameInstitution =
            formShare.educationalInstitutionId != null &&
            saved.educationalInstitutionId != null &&
            saved.educationalInstitutionId ==
                formShare.educationalInstitutionId;

        return sameUser || sameExternalAuthor || sameInstitution;
      });

      if (savedShare == null) continue;

      formShare.percentage.value = double.parse(
        savedShare.percentage.toStringAsFixed(2),
      );

      formShare.percentageController.text = formShare.percentage.value
          .toStringAsFixed(2);
    }

    shares.refresh();
  }

  void _buildSharesFromProcess(ProcessResponseEntity process) {
    shares.clear();

    final creator = process.creator;

    final members = process.authors
        .where((author) => author.id != creator.id)
        .toList();

    final externalMembers = process.externalAuthors;

    final totalParticipants = members.length + externalMembers.length;

    final availableForMembers =
        100.0 - universityFixedPercentage - creatorMinimumPercentage;

    final memberPercentages = _distributePercentage(
      total: availableForMembers,
      quantity: totalParticipants,
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

    int percentageIndex = 0;

    for (final member in members) {
      shares.add(
        ShareFormModel(
          type: ShareType.member,
          displayName: _getUserName(member),
          userId: member.id,
          percentage: memberPercentages[percentageIndex].obs,
        ),
      );

      percentageIndex++;
    }

    for (final externalMember in externalMembers) {
      shares.add(
        ShareFormModel(
          type: ShareType.memberExternal,
          displayName: _getExternalAuthorName(externalMember),
          externalAuthorId: externalMember.id,
          percentage: memberPercentages[percentageIndex].obs,
        ),
      );

      percentageIndex++;
    }

    _syncControllers();
    shares.refresh();
  }

  String _getExternalAuthorName(ExternalAuthorEntity externalAuthor) {
    final fullName = externalAuthor.fullName.trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    final email = externalAuthor.email.trim();

    if (email.isNotEmpty) {
      return email;
    }

    return "Membro externo #${externalAuthor.id ?? '-'}";
  }

  List<double> _distributePercentage({
    required double total,
    required int quantity,
  }) {
    if (quantity <= 0) return [];

    final base = double.parse((total / quantity).toStringAsFixed(2));
    final values = List<double>.filled(quantity, base);

    final currentTotal = values.fold(0.0, (sum, value) => sum + value);
    final difference = double.parse((total - currentTotal).toStringAsFixed(2));

    values[quantity - 1] = double.parse(
      (values.last + difference).toStringAsFixed(2),
    );

    return values;
  }

  String _getUserName(ProcessUserEntity user) {
    if (user.fullName.trim().isNotEmpty) return user.fullName;
    if ((user.email ?? '').trim().isNotEmpty) return user.email!;
    return "Usuário #${user.id}";
  }

  void updatePercentage(int index, double newValue, {bool fromText = false}) {
    final targetShare = shares[index];

    if (targetShare.isLocked) {
      AppToast.warning("A cota da universidade é fixa em 70%.");
      return;
    }

    double originalNewValue = newValue;

    if (newValue < targetShare.minPercentage) {
      newValue = targetShare.minPercentage;
    }

    double lockedSum = shares
        .where((s) => s.isLocked)
        .fold(0.0, (sum, s) => sum + s.percentage.value);

    double maxAllowed = 100.0 - lockedSum;

    double reservedMin = shares
        .where((s) => !s.isLocked && s != targetShare)
        .fold(0.0, (sum, s) => sum + s.minPercentage);

    if (newValue > (maxAllowed - reservedMin)) {
      newValue = maxAllowed - reservedMin;
    }

    final oldValue = targetShare.percentage.value;
    double delta = newValue - oldValue;

    if (delta == 0) return;

    targetShare.percentage.value = double.parse(newValue.toStringAsFixed(2));

    if (!fromText || newValue != originalNewValue) {
      targetShare.percentageController.text = targetShare.percentage.value
          .toStringAsFixed(2);
    }

    var otherShares = shares
        .where((s) => !s.isLocked && s != targetShare)
        .toList();

    if (otherShares.isNotEmpty) {
      double deltaPerShare = delta / otherShares.length;

      for (var other in otherShares) {
        double newOtherValue = other.percentage.value - deltaPerShare;

        if (newOtherValue < other.minPercentage) {
          newOtherValue = other.minPercentage;
        }

        other.percentage.value = double.parse(newOtherValue.toStringAsFixed(2));
        other.percentageController.text = other.percentage.value
            .toStringAsFixed(2);
      }

      _fixRounding(targetShare);
    }

    shares.refresh();
  }

  void _fixRounding(ShareFormModel targetShare) {
    double currentTotal = shares.fold(
      0.0,
      (sum, s) => sum + s.percentage.value,
    );

    double diff = 100.0 - currentTotal;

    if (diff != 0) {
      var flexibleShares = shares.where((s) => !s.isLocked && s != targetShare);

      var flexibleShare = flexibleShares.isNotEmpty
          ? flexibleShares.last
          : null;

      if (flexibleShare != null) {
        flexibleShare.percentage.value = double.parse(
          (flexibleShare.percentage.value + diff).toStringAsFixed(2),
        );

        flexibleShare.percentageController.text = flexibleShare.percentage.value
            .toStringAsFixed(2);
      }
    }
  }

  void requestUniversityChange() {
    AppToast.warning(
      "Para alterar a cota da universidade é necessário solicitar uma alteração.",
    );
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

    final entity = ProcessRoyaltyDistributionRequestModel.fromJson(
      json,
    ).toEntity();

    if (isEditMode.value) {
      await _putProcessRoyaltyDistribution(entity);
    } else {
      await _postProcessRoyaltyDistribution(entity);
    }
  }

  Future<void> _postProcessRoyaltyDistribution(
    ProcessRoyaltyDistributionRequestEntity entity,
  ) async {
    try {
      isLoading.value = true;

      final result = await _postRoyaltyDistribution(entity);

      result.fold(
        (failure) {
          AppToast.error(failure.message);
        },
        (success) {
          AppToast.success(success);

          if (openedFromProcessFlow.value) {
            Get.offAllNamed(AppRoutes.home);
          } else {
            Get.back(result: process.value!.id);
          }
        },
      );
    } catch (e) {
      AppToast.error(
        "Erro inesperado ao cadastrar distribuição de cotas ao processo ${process.value!.id}.",
      );
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _putProcessRoyaltyDistribution(
    ProcessRoyaltyDistributionRequestEntity entity,
  ) async {
    final id = distributionId.value;

    if (id == null) {
      AppToast.error("ID da distribuição não encontrado.");
      return;
    }

    try {
      isLoading.value = true;

      final result = await _putRoyaltyDistribution(id, entity);

      result.fold(
        (failure) {
          AppToast.error(failure.message);
        },
        (success) {
          AppToast.success(success);
          if (isEdit) {
            Get.toNamed(AppRoutes.home);
          } else {
            Get.back(result: process.value!.id);
          }
        },
      );
    } catch (e) {
      AppToast.error(
        "Erro inesperado ao atualizar distribuição de cotas do processo ${process.value!.id}.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _syncControllers() {
    for (final share in shares) {
      share.percentageController.text = share.percentage.value.toStringAsFixed(
        2,
      );
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
