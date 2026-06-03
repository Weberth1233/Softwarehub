import 'package:get/get.dart';

import '../../../../../domain/core/errors/failures.dart';
import '../../../../../domain/entities/address_api_entity.dart';
import '../../../../../domain/entities/educational_institution_entity.dart';
import '../../../../../domain/entities/types_link_entity.dart';
import '../../../../../domain/entities/user/user_entity.dart';
import '../../../../../domain/entities/user_educational_institution_link_entity.dart';
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

  final RxBool isLoadingSubmit = false.obs;
  final RxBool isLoadingCep = false.obs;
  final RxBool isLoadingEducationalInstitutions = false.obs;
  final RxBool isLoadingTypesLinks = false.obs;

  final RxString message = ''.obs;

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

  Future<void> fetchInitialData() async {
    await Future.wait([fetchEducationalInstitutions(), fetchTypesLinks()]);
  }

  Future<void> post(UserEntity user) async {
    if (isLoadingSubmit.value) return;

    try {
      isLoadingSubmit.value = true;
      message.value = '';

      final result = await _postUser(user);

      result.fold(
        (Failure failure) {
          message.value = failure.message;
        },
        (success) {
          message.value = success;
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
          message.value = failure.message;
        },
        (success) {
          message.value = success;
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
          message.value = failure.message;
          Get.snackbar('Erro', 'Não foi possível buscar o CEP');
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
          message.value = failure.message;
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
          message.value = failure.message;
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
      Get.snackbar('Atenção', 'Esse vínculo já foi adicionado.');
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
