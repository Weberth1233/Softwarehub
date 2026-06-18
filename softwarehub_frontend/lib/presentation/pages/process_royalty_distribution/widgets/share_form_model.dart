import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ShareType {
  university,
  creator,
  member,
  memberExternal,
}

extension ShareTypeExtension on ShareType {
  String get label {
    switch (this) {
      case ShareType.university:
        return "Universidade";
      case ShareType.creator:
        return "Criador";
      case ShareType.member:
        return "Membro";
      case ShareType.memberExternal:
        return "Membro externo";
    }
  }

  String get apiValue {
    switch (this) {
      case ShareType.university:
        return "UNIVERSITY";
      case ShareType.creator:
        return "CREATOR";
      case ShareType.member:
        return "MEMBER";
      case ShareType.memberExternal:
        return "MEMBER_EXTERNAL";
    }
  }
}

class ShareFormModel {
  final String id;
  final ShareType type;
  final String displayName;

  final int? userId;
  final int? externalAuthorId;
  final int? educationalInstitutionId;

  final RxDouble percentage;
  final double minPercentage;
  final bool isLocked;

  final TextEditingController percentageController;

  ShareFormModel({
    String? id,
    required this.type,
    required this.displayName,
    this.userId,
    this.externalAuthorId,
    this.educationalInstitutionId,
    required this.percentage,
    this.minPercentage = 0,
    this.isLocked = false,
  })  : id = id ??
            _buildId(
              type,
              userId,
              externalAuthorId,
              educationalInstitutionId,
            ),
        percentageController = TextEditingController();

  static String _buildId(
    ShareType type,
    int? userId,
    int? externalAuthorId,
    int? educationalInstitutionId,
  ) {
    return "${type.name}_${userId ?? externalAuthorId ?? educationalInstitutionId ?? DateTime.now().microsecondsSinceEpoch}";
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type.apiValue,
      "userId": userId,
      "externalAuthorId": externalAuthorId,
      "educationalInstitutionId": educationalInstitutionId,
      "percentage": percentage.value,
    };
  }

  void dispose() {
    percentageController.dispose();
  }
}