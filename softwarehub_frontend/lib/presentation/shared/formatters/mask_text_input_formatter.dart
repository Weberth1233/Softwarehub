import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputMasks {
  static final cpf = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static final phone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static final cep = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  static String onlyNumbers(String value) {
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }
}