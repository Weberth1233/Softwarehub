import 'dart:convert';

class ApiErrorFormatter {
  static String formatFromBody(
    String body, {
    String fallbackMessage = 'Erro inesperado no servidor.',
  }) {
    try {
      if (body.trim().isEmpty) {
        return fallbackMessage;
      }

      final decoded = jsonDecode(body);

      if (decoded is! Map<String, dynamic>) {
        return fallbackMessage;
      }

      final mensagem = decoded['mensagem']?.toString().trim();

      final erros = decoded['erros'];

      final buffer = StringBuffer();

      if (mensagem != null && mensagem.isNotEmpty) {
        buffer.writeln(mensagem);
      } else {
        buffer.writeln(fallbackMessage);
      }

      if (erros is List && erros.isNotEmpty) {
        buffer.writeln();

        for (final e in erros) {
          if (e is Map<String, dynamic>) {
            final campo = _traduzirCampo(
              e['campo']?.toString() ?? 'Campo',
            );

            final mensagemErro = _humanizarMensagem(
              e['erro']?.toString() ?? 'Erro inválido',
            );

            buffer.writeln('• $campo: $mensagemErro');
          } else {
            buffer.writeln('• ${e.toString()}');
          }
        }
      }

      return buffer.toString().trim();
    } catch (_) {
      return fallbackMessage;
    }
  }

  static String _traduzirCampo(String campo) {
    const mapa = {
      'userName': 'Usuário',
      'password': 'Senha',
      'phoneNumber': 'Telefone',
      'fullName': 'Nome completo',
      'email': 'E-mail',
    };

    return mapa[campo] ?? campo;
  }

  static String _humanizarMensagem(String msg) {
    var m = msg.trim();

    if (m.isNotEmpty) {
      m = m[0].toUpperCase() + m.substring(1);
    }

    return m;
  }
}