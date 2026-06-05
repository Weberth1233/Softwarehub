import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareFormModel {
  ShareFormModel({
    required this.type,
    required this.displayName,
    required this.percentage,
    this.userId,
    this.educationalInstitutionId,
    this.isLocked = false,
    this.minPercentage = 0,
  }) {
    percentageController.text = percentage.value.toStringAsFixed(2);
  }

  final String id = UniqueKey().toString();

  final ShareType type;

  final String displayName;

  final int? userId;

  final int? educationalInstitutionId;

  final bool isLocked;

  final double minPercentage;

  final RxDouble percentage;

  final TextEditingController percentageController = TextEditingController();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "type": type.apiValue,
      "percentage": percentage.value,
    };

    if (type == ShareType.university) {
      map["educationalInstitutionId"] = educationalInstitutionId;
    } else {
      map["userId"] = userId;
    }

    return map;
  }

  void dispose() {
    percentageController.dispose();
  }
}

enum ShareType {
  university,
  creator,
  member,
}

extension ShareTypeExtension on ShareType {
  String get apiValue {
    switch (this) {
      case ShareType.university:
        return "UNIVERSITY";
      case ShareType.creator:
        return "CREATOR";
      case ShareType.member:
        return "MEMBER";
    }
  }

  String get label {
    switch (this) {
      case ShareType.university:
        return "Universidade";
      case ShareType.creator:
        return "Criador";
      case ShareType.member:
        return "Membro";
    }
  }
}