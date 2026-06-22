import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import 'controllers/process_royalty_distribution_controller.dart';
import 'widgets/share_form_model.dart';

class ProcessRoyaltyDistributionPage extends GetView<ProcessRoyaltyDistributionController> {
  const ProcessRoyaltyDistributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo cores estáticas baseadas no Figma para garantir a fidelidade visual
    const Color brandBlue = Color(0xFF1565C0);
    const Color bgLightBlue = Color(0xFFF4F8FB);
    const Color textDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bgLightBlue,
      // 1. Nova AppBar Branca com Subtítulo
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ThemeColor.primaryColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: brandBlue),
                onPressed: () {
                  final process = controller.process.value;
                  if (process != null) {
                    Get.back(result: process.id);
                  } else {
                    Get.back();
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Distribuição de cotas",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Defina o percentual de cada participante",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // 2. Novo Dashboard Superior
                      Obx(() => _TopDashboard(
                        processId: controller.processId,
                        processTitle: controller.processTitle,
                        totalPercentage: controller.totalPercentage,
                      )),
                      const SizedBox(height: 16),

                      // 3. Banners Informativos (Universidade e Erro Estático)
                      const _InfoBanners(),
                      const SizedBox(height: 24),

                      // 4. Container de Colaboradores
                      Container(
                        decoration: BoxDecoration(
                          color: bgLightBlue,
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Defina a porcentagem de cada colaborador",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textDark),
                              ),
                            ),
                            const Divider(height: 1, color: Colors.blue),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              if (controller.shares.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(child: Text("Nenhuma cota encontrada.")),
                                );
                              }

                              // Filtramos a universidade pois ela já está no banner estático
                              final editableShares = controller.shares.where((s) => s.type != ShareType.university).toList();

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: editableShares.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final share = editableShares[index];
                                  // Pegamos o index real no controller para os métodos funcionarem
                                  final realIndex = controller.shares.indexOf(share);

                                  return _CollaboratorRow(
                                    share: share,
                                    onSliderChanged: (val) => controller.updatePercentage(realIndex, val, fromText: false),
                                    onTextChanged: (val) => controller.updatePercentage(realIndex, val, fromText: true),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 5. Novo BottomBar Fixo
              Obx(() => _BottomActionbar(
                isValid: controller.isTotalValid,
                isLoading: controller.isLoading.value,
                onSubmit: controller.submit,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

// --- COMPONENTES AUXILIARES ---

class _TopDashboard extends StatelessWidget {
  final int processId;
  final String processTitle;
  final double totalPercentage;

  const _TopDashboard({
    super.key,
    required this.processId,
    required this.processTitle,
    required this.totalPercentage,
  });

  @override
  Widget build(BuildContext context) {
    // Paleta de cores baseada na imagem para fidelidade
    const Color primaryText = Color(0xFF1E293B);
    const Color secondaryText = Color(0xFF64748B);
    const Color brandBlue = Color(0xFF1565C0);
    const Color lightBlueBg = Color(0xFFEAF2FF);
    const Color greenBrand = Color(0xFF00A65A);
    const Color lightGreenBg = Color(0xFFD1F2E6);
    const Color dividerColor = Color(0xFFE2E8F0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),

      child: IntrinsicHeight(
        child: Row(
          children: [

            // --- BLOCO 1: Informações do Processo (Esquerda) ---
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: lightBlueBg,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: brandBlue.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.folder_outlined,
                        color: brandBlue,
                        size: 48),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          processTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              "Processo #$processId",
                              style: const TextStyle(color: secondaryText, fontSize: 14),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: lightGreenBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "Completo",
                                style: TextStyle(
                                  color: greenBrand,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- DIVISOR VERTICAL 1 ---
            const VerticalDivider(color: dividerColor, width: 32, thickness: 1.5),

            // --- BLOCO 2: Gráfico Circular (Centro) ---
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 64,
                    width: 64,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Fundo do círculo
                        CircularProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.transparent,
                          color: lightBlueBg,
                          strokeWidth: 8,
                        ),
                        // Progresso real
                        CircularProgressIndicator(
                          value: totalPercentage / 100,
                          backgroundColor: Colors.transparent,
                          color: greenBrand,
                          strokeWidth: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${totalPercentage.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: greenBrand,
                        ),
                      ),
                      const Text(
                        "Distribuição total",
                        style: TextStyle(
                          color: greenBrand,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- DIVISOR VERTICAL 2 ---
            const VerticalDivider(color: dividerColor, width: 32, thickness: 1.5),

            // --- BLOCO 3: Legendas e Resumo (Direita) ---
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendRow(
                    Icons.account_balance,
                    "UNIVERSIDADE",
                    "70%",
                    brandBlue,
                    lightBlueBg,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(height: 1, color: dividerColor.withOpacity(0.6)),
                  ),
                  _buildLegendRow(
                    Icons.people_alt_outlined,
                    "PARTICIPANTES",
                    "${(totalPercentage > 70 ? totalPercentage - 70 : 0).toStringAsFixed(0)}%",
                    brandBlue,
                    lightBlueBg,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  /// Método auxiliar para construir as linhas da legenda no bloco da direita
  Widget _buildLegendRow(IconData icon, String label, String value, Color iconColor, Color bgColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _InfoBanners extends StatelessWidget {
  const _InfoBanners({super.key});

  @override
  Widget build(BuildContext context) {
    const Color leftBgColor = Color(0xFFF4F8FE);
    const Color leftBorderColor = Color(0xFFB6D1FE); // Borda um pouco mais sutil
    const Color iconBgColor = Color(0xFFDBEAFE);
    const Color brandBlue = Color(0xFF2563EB); // Azul mais vibrante

    const Color rightBgColor = Color(0xFFFFEBEB);
    const Color rightBorderColor = Color(0xFFFFC5C5);

    const Color primaryText = Color(0xFF0F172A); // Quase preto, mais forte que o anterior
    const Color secondaryText = Color(0xFF64748B);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- BANNER ESQUERDO (Universidade) ---
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), // Mais respiro interno
              decoration: BoxDecoration(
                color: leftBgColor,
                border: Border.all(color: ThemeColor.primaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  // Ícone Universidade
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.account_balance, color: brandBlue, size: 55),
                  ),
                  const SizedBox(width: 14),

                  // Texto Universidade e Badge FIXO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ProcessRoyaltyDistributionController.unitinsName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: primaryText,
                            fontSize: 21,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock_outline, size: 19, color: brandBlue),
                              const SizedBox(width: 2),
                              const Text(
                                "FIXO",
                                style: TextStyle(
                                  color: brandBlue,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // Ícone Escudo
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.shield, color: brandBlue, size: 60),
                        Icon(Icons.lock, color: Colors.white, size: 28), // Cadeado levemente menor
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Textos da Porcentagem
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "70%",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900, // Peso máximo para saltar na tela
                          color: Colors.black,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Cota institucional protegida",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: primaryText,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Esta participação é definida\npelas regras do processo",
                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryText,
                          height: 1.2,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // --- BANNER DIREITO (Aviso) ---
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: rightBgColor,
                border: Border.all(color: rightBorderColor, width: 1.9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  // Ícone de Informação (Círculo reduzido)
                  Container(
                    width: 36, // Círculo menor para não engolir o texto
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "i",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Texto do Aviso (Com peso corrigido)
                  const Expanded(
                    child: Text(
                      "A soma das cotas deve ser exatamente 100% para salvar a distribuição.",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: primaryText,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollaboratorRow extends StatelessWidget {
  final ShareFormModel share;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onTextChanged;

  const _CollaboratorRow({required this.share, required this.onSliderChanged, required this.onTextChanged});

  @override
  Widget build(BuildContext context) {
    final isCreator = share.type == ShareType.creator;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Perfil
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const CircleAvatar(radius: 24, backgroundColor: Color(0xFFE3F2FD), child: Icon(Icons.person, color: Colors.blue, size: 32)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(share.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(isCreator ? "CRIADOR" : "MEMBRO", style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Área Estática do Slider (Para bater com o design)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Cota atribuída", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                Obx(() => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.blue,
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
                    thumbColor: Colors.blue,
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: share.percentage.value.clamp(0, 100),
                    min: 0,
                    max: 100,
                    onChanged: onSliderChanged,
                  ),
                )),
                if (isCreator)
                  Container(
                    margin: const EdgeInsets.only(left: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    color: Colors.blue.withOpacity(0.1),
                    child: const Text("Mínimo obrigatório criador", style: TextStyle(fontSize: 8, color: Colors.blue)),
                  )
              ],
            ),
          ),

          // Input Box Lateral Estilo Figma
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                  child: const Text("Maximo: 30%", style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _SquareBtn(icon: Icons.remove, onPressed: () => onSliderChanged(share.percentage.value - 1)),
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.withOpacity(0.3)))),
                      child: Center(
                        child: Obx(() => Text("${share.percentage.value.toStringAsFixed(0)} %", style: const TextStyle(fontWeight: FontWeight.bold))),
                      ),
                    ),
                    _SquareBtn(icon: Icons.add, onPressed: () => onSliderChanged(share.percentage.value + 1)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SquareBtn({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        color: const Color(0xFF1565C0),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _BottomActionbar extends StatelessWidget {
  final bool isValid;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _BottomActionbar({required this.isValid, required this.isLoading, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isValid ? "Distribuição completa" : "Distribuição pendente",
                    style: TextStyle(color: isValid ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Text("Todas as cotas foram distribuídas.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFF004093),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: (isLoading || !isValid) ? null : onSubmit,
            icon: isLoading
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.save_outlined, color: Colors.white),
            label: Text(isLoading ? "Salvando..." : "Salvar distribuição", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}