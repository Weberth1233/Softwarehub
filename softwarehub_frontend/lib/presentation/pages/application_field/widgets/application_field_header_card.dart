import 'package:flutter/material.dart';

class ApplicationFieldHeaderCard extends StatelessWidget {
  final int totalAreas;
  final int totalFields;
  final int totalSelected;
  final bool isDesktop;

  const ApplicationFieldHeaderCard({
    super.key,
    required this.totalAreas,
    required this.totalFields,
    this.totalSelected = 0,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- PARTE SUPERIOR: Cabeçalho com Ícone ---
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.snippet_folder_outlined,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Campos de Aplicação",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                        fontSize: 20,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Resumo geral do cadastro",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          //  Cards de Estatísticas
          isDesktop
              ? Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.account_tree_outlined,
                  iconColor: colors.primary,
                  iconBgColor: colors.primary.withOpacity(0.08),
                  value: totalAreas.toString(),
                  title: "Áreas",
                  subtitle: "Total de áreas cadastradas",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.description_outlined,
                  iconColor: colors.primary,
                  iconBgColor: colors.primary.withOpacity(0.08),
                  value: totalFields.toString(),
                  title: "Campos",
                  subtitle: "Total de campos cadastrados",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  iconColor: Colors.green.shade600,
                  iconBgColor: Colors.green.withOpacity(0.1),
                  value: totalSelected.toString(),
                  title: "Selecionados",
                  subtitle: "Campos selecionados",
                ),
              ),
            ],
          )
              : Column(
            children: [
              _buildStatCard(
                icon: Icons.account_tree_outlined,
                iconColor: colors.primary,
                iconBgColor: colors.primary.withOpacity(0.08),
                value: totalAreas.toString(),
                title: "Áreas",
                subtitle: "Total de áreas cadastradas",
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.description_outlined,
                iconColor: colors.primary,
                iconBgColor: colors.primary.withOpacity(0.08),
                value: totalFields.toString(),
                title: "Campos",
                subtitle: "Total de campos cadastrados",
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                icon: Icons.check_circle,
                iconColor: Colors.green.shade600,
                iconBgColor: Colors.green.withOpacity(0.1),
                value: totalSelected.toString(),
                title: "Selecionados",
                subtitle: "Campos selecionados",
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método encapsulado para montar a interface dos sub-cards repetitivos.
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}