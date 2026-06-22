part of '../process_detail_page.dart';

extension _ProcessDetailPageContent on _ProcessDetailPageState {
  Widget _buildSelectedContent(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    String title;
    String subtitle;
    Widget content;

    switch (_selectedIndex) {
      case 0:
        title = "SOLICITANTE";
        subtitle = "Dados de quem criou o processo.";
        content = this._buildCreatorCard(context, entity);
        break;
      case 1:
        title = "MEMBROS";
        subtitle = "Pessoas vinculadas ao processo.";
        content = this._buildMembersList(context, entity);
        break;
      case 2:
        title = "MEMBROS EXTERNOS";
        subtitle = "Pessoas externas vinculadas ao processo.";
        content = this._buildExternalMembersList(context, entity);
        break;
      case 3:
        title = "DADOS DO PROCESSO";
        subtitle = "Informações preenchidas no formulário.";
        content = this._buildDynamicForm(context, entity);
        break;
      case 4:
        title = "ANEXOS";
        subtitle =
            "Arquivos relacionados ao processo. Clique no processo para enviá-lo assinado.";
        content = this._buildAttachmentsList(context, entity);
        break;
      case 5:
        title = "CORREÇÕES / JUSTIFICATIVAS";
        subtitle = "Correções e observações.";
        content = this._buildFixesList(context, entity);
        break;
      case 6:
        title = "CLASSIFICAÇÃO DE NICE";
        subtitle = "Classificação vinculada ao processo.";
        content = this._buildApplicationFieldsCard(context, entity);
        break;
      case 7:
        title = "DISTRIBUIÇÃO DE COTAS";
        subtitle = "Percentuais de royalties vinculados ao processo.";
        content = this._buildRoyaltyDistributionsList(context, entity);
        break;
      default:
        title = "";
        subtitle = "";
        content = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colors.tertiary,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: colors.secondary),
        ),
        const SizedBox(height: 18),
        content,
      ],
    );
  }
}
