part of '../process_detail_page.dart';

extension _ProcessDetailPageFormatters on _ProcessDetailPageState {
  String _formatPhone(String phone) {
    final numbers = phone.replaceAll(RegExp(r'\D'), '');

    if (numbers.length == 11) {
      return '(${numbers.substring(0, 2)}) '
          '${numbers.substring(2, 7)}-'
          '${numbers.substring(7)}';
    }

    if (numbers.length == 10) {
      return '(${numbers.substring(0, 2)}) '
          '${numbers.substring(2, 6)}-'
          '${numbers.substring(6)}';
    }

    return phone;
  }

  String _formatBirthDate(String date) {
    try {
      if (date.trim().isEmpty) return "Data de nascimento não informada";

      final parsedDate = DateTime.tryParse(date);

      if (parsedDate == null) return date;

      return '${parsedDate.day.toString().padLeft(2, '0')}/'
          '${parsedDate.month.toString().padLeft(2, '0')}/'
          '${parsedDate.year}';
    } catch (_) {
      return date;
    }
  }

  String _formatCreatedAt(dynamic date) {
    try {
      if (date == null) return "Data não informada";

      final parsedDate = date is DateTime
          ? date
          : DateTime.tryParse(date.toString());

      if (parsedDate == null) return "Data inválida";

      return DateFormat("d 'de' MMM 'de' y", "pt_BR").format(parsedDate);
    } catch (_) {
      return "Data inválida";
    }
  }
}
