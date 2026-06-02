import '../../../domain/entities/user/address_entity.dart';

class AddressModel {
  final String zipCode;
  final String street;

  final String complement;
  final String neighborhood;
  final String city;
  final String state;

  AddressModel({
    required this.zipCode,
    required this.street,

    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  /// Converte AddressEntity -> AddressModel
  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      zipCode: entity.zipCode,
      street: entity.street,
      complement: entity.complement,
      neighborhood: entity.neighborhood,
      city: entity.city,
      state: entity.state,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      zipCode: json['zipCode'],
      street: json['street'],
      complement: json['complement'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      state: json['state'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "zipCode": zipCode,
      "street": street,
      "complement": complement,
      "neighborhood": neighborhood,
      "city": city,
      "state": state,
    };
  }

  AddressEntity toEntity() {
    return AddressEntity(
      city: city,
      complement: complement,
      neighborhood: neighborhood,
      state: state,
      street: street,
      zipCode: zipCode,
    );
  }
}
