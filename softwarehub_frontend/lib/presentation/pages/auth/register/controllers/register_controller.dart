import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/app_toast.dart';
import '../../../../../domain/core/errors/failures.dart';
import '../../../../../domain/entities/address_api_entity.dart';
import '../../../../../domain/entities/educational_institution_entity.dart';
import '../../../../../domain/entities/types_link_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../domain/entities/user/user_educational_institution_link_entity.dart';
import '../../../../../domain/usecases/address/get_by_zipcode.dart';
import '../../../../../domain/usecases/educational_institution/get_educational_institutions.dart';
import '../../../../../domain/usecases/types_link/get_types_links.dart';
import '../../../../../domain/usecases/users/post_user.dart';
import '../../../../../domain/usecases/users/put_user.dart';

class RegisterController extends GetxController {
  final PostUser _postUser;
  final PutUser _putUser;
  final GetByZipcode _getByZipcode;
  final GetEducationalInstitutions _getEducationalInstitutions;
  final GetTypesLinks _getTypesLinks;

  RegisterController(
      this._postUser,
      this._putUser,
      this._getByZipcode,
      this._getEducationalInstitutions,
      this._getTypesLinks,
      );

  // Dados pessoais
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Data de nascimento
  final TextEditingController birthDayController = TextEditingController();
  final TextEditingController birthMonthController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();

  // Endereço
  final TextEditingController cepController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  final RxBool isLoadingSubmit = false.obs;
  final RxBool isLoadingCep = false.obs;
  final RxBool isLoadingEducationalInstitutions = false.obs;
  final RxBool isLoadingTypesLinks = false.obs;

  final RxString message = ''.obs;

  /// Mapa de erros por campo, populado a partir das mensagens de erro
  /// retornadas pelo backend (heurística por palavras-chave).
  final RxMap<String, String?> fieldErrors = <String, String?>{}.obs;

  final Rxn<AddressApiEntity> addressApiEntity = Rxn<AddressApiEntity>();

  final RxList<EducationalInstitutionEntity> educationalInstitutions =
      <EducationalInstitutionEntity>[].obs;

  final RxList<TypesLinkEntity> typesLinks = <TypesLinkEntity>[].obs;

  final RxList<UserEducationalInstitutionLinkEntity>
  selectedEducationalInstitutionLinks =
      <UserEducationalInstitutionLinkEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    cpfController.clear();
    professionController.clear();
    phoneController.clear();
    passwordController.clear();

    birthDayController.clear();
    birthMonthController.clear();
    birthYearController.clear();

    cepController.clear();
    streetController.clear();
    numberController.clear();
    complementController.clear();
    neighborhoodController.clear();
    cityController.clear();
    stateController.clear();

    fieldErrors.clear();

    clearEducationalInstitutionLinks();
  }

  String get birthDateFormatted {
    return "${birthYearController.text}-"
        "${birthMonthController.text.padLeft(2, '0')}-"
        "${birthDayController.text.padLeft(2, '0')}";
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    cpfController.dispose();
    professionController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    birthDayController.dispose();
    birthMonthController.dispose();
    birthYearController.dispose();

    cepController.dispose();
    streetController.dispose();
    numberController.dispose();
    complementController.dispose();
    neighborhoodController.dispose();
    cityController.dispose();
    stateController.dispose();

    super.onClose();
  }

  Future<void> fetchInitialData() async {
    await Future.wait([fetchEducationalInstitutions(), fetchTypesLinks()]);
  }

  /// Limpa o erro de um campo específico (chamado ao usuário editar o campo).
  void clearFieldError(String key) {
    if (fieldErrors[key] != null) {
      fieldErrors[key] = null;
    }
  }

  /// Mapeia a mensagem de erro retornada pelo backend para o campo
  /// correspondente, usando palavras-chave presentes na mensagem.
  void _mapFailureToField(Failure failure) {
    fieldErrors.clear();

    final msg = failure.message.toLowerCase();

    if (msg.contains('cpf')) {
      fieldErrors['cpf'] = failure.message;
    } else if (msg.contains('e-mail') || msg.contains('email')) {
      fieldErrors['email'] = failure.message;
    } else if (msg.contains('nome de usuário') ||
        msg.contains('usuário') ||
        msg.contains('username')) {
      fieldErrors['userName'] = failure.message;
    } else if (msg.contains('telefone')) {
      fieldErrors['phone'] = failure.message;
    } else if (msg.contains('cep')) {
      fieldErrors['cep'] = failure.message;
    }

    AppToast.error(failure.message);
  }

  Future<void> post(UserEntity user) async {
    if (isLoadingSubmit.value) return;

    try {
      isLoadingSubmit.value = true;
      message.value = '';

      final result = await _postUser(user);

      result.fold(
            (Failure failure) {
          _mapFailureToField(failure);
        },
            (success) {
          AppToast.success(success);
          clearForm();
        },
      );
    } finally {
      isLoadingSubmit.value = false;
    }
  }

  Future<void> updateUserLogged(int idUser, UserEntity user) async {
    if (isLoadingSubmit.value) return;

    try {
      isLoadingSubmit.value = true;
      message.value = '';

      final result = await _putUser(idUser, user);

      result.fold(
            (Failure failure) {
          _mapFailureToField(failure);
        },
            (success) {
          AppToast.success(success);
          fieldErrors.clear();
        },
      );
    } finally {
      isLoadingSubmit.value = false;
    }
  }

  Future<AddressApiEntity?> getByZipCode(String cep) async {
    if (isLoadingCep.value) return null;

    try {
      isLoadingCep.value = true;

      final result = await _getByZipcode(cep);

      return result.fold(
            (Failure failure) {
          AppToast.error(failure.message);
          return null;
        },
            (AddressApiEntity address) {
          addressApiEntity.value = address;
          return address;
        },
      );
    } finally {
      isLoadingCep.value = false;
    }
  }

  Future<void> fetchEducationalInstitutions() async {
    if (isLoadingEducationalInstitutions.value) return;

    try {
      isLoadingEducationalInstitutions.value = true;
      message.value = '';

      final result = await _getEducationalInstitutions();

      result.fold(
            (Failure failure) {
          AppToast.error(failure.message);
        },
            (List<EducationalInstitutionEntity> result) {
          educationalInstitutions.assignAll(result);
        },
      );
    } finally {
      isLoadingEducationalInstitutions.value = false;
    }
  }

  Future<void> fetchTypesLinks() async {
    if (isLoadingTypesLinks.value) return;

    try {
      isLoadingTypesLinks.value = true;
      message.value = '';

      final result = await _getTypesLinks();

      result.fold(
            (Failure failure) {
          AppToast.error(failure.message);
        },
            (List<TypesLinkEntity> result) {
          typesLinks.assignAll(result);
        },
      );
    } finally {
      isLoadingTypesLinks.value = false;
    }
  }

  void addEducationalInstitutionLink({
    required EducationalInstitutionEntity educationalInstitution,
    required TypesLinkEntity typesLink,
  }) {
    final alreadyExists = selectedEducationalInstitutionLinks.any(
          (link) =>
      link.educationalInstitution.id == educationalInstitution.id &&
          link.typesLink.id == typesLink.id,
    );

    if (alreadyExists) {
      AppToast.warning("Atenção - Esse vínculo já foi adicionado!");

      return;
    }

    selectedEducationalInstitutionLinks.add(
      UserEducationalInstitutionLinkEntity(
        educationalInstitution: educationalInstitution,
        typesLink: typesLink,
      ),
    );
  }

  void removeEducationalInstitutionLink(
      UserEducationalInstitutionLinkEntity link,
      ) {
    selectedEducationalInstitutionLinks.remove(link);
  }

  void clearEducationalInstitutionLinks() {
    selectedEducationalInstitutionLinks.clear();
  }

  List<UserEducationalInstitutionLinkEntity>
  getSelectedEducationalInstitutionLinks() {
    return selectedEducationalInstitutionLinks.toList();
  }

  bool get hasEducationalInstitutionLinks {
    return selectedEducationalInstitutionLinks.isNotEmpty;
  }
}