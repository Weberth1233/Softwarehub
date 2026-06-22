part of '../process_detail_page.dart';

extension _ProcessDetailPagePeople on _ProcessDetailPageState {
  Widget _buildMembersList(BuildContext context, ProcessResponseEntity entity) {
    if (entity.authors.isEmpty) {
      return this._buildEmptyState(
        context,
        icon: Icons.group_outlined,
        message: "Nenhum membro interno vinculado ao processo.",
        //process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.authors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final author = entity.authors[index];

        return this._buildPersonRowCard(
          context,
          name: author.fullName,
          email: author.email,
          birthDate: author.birthDate,
          phoneNumber: author.phoneNumber,
          profession: author.profession,
          trailingIcon: Icons.person_outline,
          userEducationalInstitutionLinks:
              entity.creator.userEducationalInstitutionLinks,
        );
      },
    );
  }

  Widget _buildExternalMembersList(
    BuildContext context,
    ProcessResponseEntity entity,
  ) {
    if (entity.externalAuthors.isEmpty) {
      return this._buildEmptyState(
        context,
        icon: Icons.group_outlined,
        message: "Nenhum membro externo vinculado ao processo.",
        // process: entity,
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entity.externalAuthors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final author = entity.externalAuthors[index];

        return this._buildPersonRowCard(
          context,
          name: author.fullName,
          email: author.email,
          birthDate: "",
          phoneNumber: "",
          profession: "",
          trailingIcon: Icons.person_outline,
          userEducationalInstitutionLinks: [],
        );
      },
    );
  }

  Widget _buildCreatorCard(BuildContext context, ProcessResponseEntity entity) {
    return this._buildPersonRowCard(
      context,
      name: entity.creator.fullName,
      email: entity.creator.email,
      birthDate: entity.creator.birthDate,
      phoneNumber: entity.creator.phoneNumber,
      profession: entity.creator.profession,
      userEducationalInstitutionLinks:
          entity.creator.userEducationalInstitutionLinks,
      trailingIcon: Icons.star_border,
    );
  }

  Widget _buildPersonRowCard(
    BuildContext context, {
    required String name,
    required String email,
    required String phoneNumber,
    required String birthDate,
    required String profession,
    required List<UserEducationalInstitutionLinkEntity>
    userEducationalInstitutionLinks,
    required IconData trailingIcon,
  }) {
    final colors = Theme.of(context).colorScheme;

    final displayName = name.trim().isNotEmpty
        ? name.trim()
        : "Nome não informado";

    final firstLetter = displayName != "Nome não informado"
        ? displayName.substring(0, 1).toUpperCase()
        : "?";

    return this._buildSimpleCard(
      context,
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: colors.primary,
          child: Text(
            firstLetter,
            style: TextStyle(
              color: colors.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text(
          displayName,
          style: TextStyle(fontWeight: FontWeight.w800, color: colors.tertiary),
        ),
        subtitle: Text(
          email.trim().isNotEmpty ? email : "E-mail não informado",
          style: TextStyle(color: colors.secondary, fontSize: 13),
        ),
        trailing: Icon(trailingIcon, color: colors.secondary),
        children: [
          const SizedBox(height: 8),

          this._buildInfoRow(
            context,
            icon: Icons.email_outlined,
            label: "E-mail",
            value: email.trim().isNotEmpty ? email : "E-mail não informado",
          ),

          this._buildInfoRow(
            context,
            icon: Icons.phone_outlined,
            label: "Telefone",
            value: phoneNumber.trim().isNotEmpty
                ? this._formatPhone(phoneNumber)
                : "Telefone não informado",
          ),

          this._buildInfoRow(
            context,
            icon: Icons.cake_outlined,
            label: "Data de nascimento",
            value: birthDate.trim().isNotEmpty
                ? this._formatBirthDate(birthDate)
                : "Data de nascimento não informada",
          ),

          this._buildInfoRow(
            context,
            icon: Icons.work_outline,
            label: "Profissão",
            value: profession.trim().isNotEmpty
                ? profession
                : "Profissão não informada",
          ),

          if (userEducationalInstitutionLinks.isNotEmpty) ...[
            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.school_outlined, size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  "Instituições de ensino",
                  style: TextStyle(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: userEducationalInstitutionLinks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final result = userEducationalInstitutionLinks[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.outline.withOpacity(0.15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      this._buildInfoRow(
                        context,
                        icon: Icons.account_balance_outlined,
                        label: "Instituição",
                        value: result.educationalInstitution.name,
                        compact: true,
                      ),
                      const SizedBox(height: 6),
                      this._buildInfoRow(
                        context,
                        icon: Icons.badge_outlined,
                        label: "Vínculo",
                        value: result.typesLink.name,
                        compact: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool compact = false,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: colors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.trim().isNotEmpty ? value : "Não informado",
                  style: TextStyle(
                    color: colors.tertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
