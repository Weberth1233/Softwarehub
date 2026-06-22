part of '../process_detail_page.dart';

extension _ProcessDetailPageRoyalties on _ProcessDetailPageState {
  Widget _buildRoyaltyDistributionsList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    final colors = Theme.of(context).colorScheme;

    if (entity.royaltyDistributions.isEmpty) {
      return this._buildEmptyRoyaltDistributionState(
        context,
        icon: Icons.pie_chart_outline,
        message: "Nenhuma distribuição de cotas vinculada a este processo.",
        process: entity,
      );
    }

    final activeDistributions = entity.royaltyDistributions
        .where((distribution) => distribution.status == "ACTIVE")
        .toList();

    final distributionsToShow = activeDistributions.isNotEmpty
        ? activeDistributions
        : entity.royaltyDistributions;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: distributionsToShow.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final distribution = distributionsToShow[index];

        final totalPercentage = distribution.shares.fold<double>(
          0,
          (previousValue, share) => previousValue + share.percentage,
        );

        final isActive = distribution.status == "ACTIVE";

        return this._buildSimpleCard(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.pie_chart_outline, color: colors.primary),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Distribuição versão ${distribution.version}",
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  TextButton.icon(
                    onPressed: () async {
                      final result = await Get.toNamed(
                        AppRoutes.processRoyaltyDistributionById(entity.id),
                        arguments: {
                          "distributionId": distribution.id,
                          'openedFromProcessFlow': false,
                        },
                      );

                      if (result != null && result is int) {
                        print("Atualizando o processo");
                        await controller.fetchProcess(result);
                      }
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: colors.primary,
                    ),
                    label: Text(
                      "Editar",
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: colors.primary.withOpacity(0.08),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (isActive ? Colors.green : Colors.grey)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isActive ? "Ativa" : "Inativa",
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Total distribuído: ${totalPercentage.toStringAsFixed(2)}%",
                style: TextStyle(
                  color: colors.tertiary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              if (distribution.shares.isEmpty)
                this._buildEmptyState(
                  context,
                  icon: Icons.percent_outlined,
                  message: "Nenhuma cota encontrada nesta distribuição.",
                  //process: entity,
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: distribution.shares.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, shareIndex) {
                    final share = distribution.shares[shareIndex];

                    final title = this._getRoyaltyShareTitle(share);
                    final subtitle = this._getRoyaltyShareSubtitle(share);
                    final icon = this._getRoyaltyShareIcon(share.type);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: colors.primary,
                            child: Icon(
                              icon,
                              color: colors.onSecondary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: colors.tertiary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: colors.secondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              "${share.percentage.toStringAsFixed(2)}%",
                              style: TextStyle(
                                color: colors.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _getRoyaltyShareTitle(dynamic share) {
    if (share.type == "UNIVERSITY") {
      final institutionName = share.educationalInstitutionName;

      if (institutionName != null &&
          institutionName.toString().trim().isNotEmpty) {
        return institutionName.toString();
      }

      return "Instituição não informada";
    }

    final userName = share.userName;
    final externalAuthorName = share.externalAuthorName;

    if (userName != null && userName.toString().trim().isNotEmpty) {
      return userName.toString();
    }
    else if(externalAuthorName != null && externalAuthorName.toString().trim().isNotEmpty ){
      return externalAuthorName.toString();
    }

    return "Usuário não informado";
  }

  String _getRoyaltyShareSubtitle(dynamic share) {
    switch (share.type) {
      case "UNIVERSITY":
        return "Instituição de ensino";
      case "CREATOR":
        return "Criador";
      case "MEMBER":
        return "Membro";
      case "MEMBER_EXTERNAL":
        return "Membro Externo";
      default:
        return share.type.toString();
    }
  }

  IconData _getRoyaltyShareIcon(String type) {
    switch (type) {
      case "UNIVERSITY":
        return Icons.account_balance_outlined;
      case "CREATOR":
        return Icons.star_border;
      case "MEMBER":
        return Icons.person_outline;
      default:
        return Icons.percent_outlined;
    }
  }

  Widget _buildEmptyRoyaltDistributionState(
    BuildContext context, {
    required IconData icon,
    required String message,
    required ProcessResponseEntity process,
  }) {
    final colors = Theme.of(context).colorScheme;

    return this._buildSimpleCard(
      context,
      child: Row(
        children: [
          Icon(icon, color: colors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              final result = await Get.toNamed(
                AppRoutes.processRoyaltyDistributionById(process.id),
                arguments: {'openedFromProcessFlow': false},
              );
              if (result != null && result is int) {
                print("Atualizando o processo");
                await controller.fetchProcess(result);
              }
            },
            child: Text(
              "Distribuir cotas ao processo",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
