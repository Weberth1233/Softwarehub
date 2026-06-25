import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import 'controllers/process_royalty_distribution_controller.dart';
import 'widgets/share_form_model.dart';
import '../../shared/widgets/shared_background.dart';

class ProcessRoyaltyDistributionPage
    extends GetView<ProcessRoyaltyDistributionController> {
  const ProcessRoyaltyDistributionPage({super.key});

  @override
  Widget build(BuildContext context) {

    const Color brandBlue = Color(0xFF1565C0);
    const Color bgLightBlue = Color(0xFFF4F8FB);
    const Color textDark = Color(0xFF1E293B);

    // 1. O Container cor sólida
    return Container(
        color: const Color(0xFFCBD5E1),

        child: SharedBackground(

            child: Scaffold(
              backgroundColor: Colors.transparent,

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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Defina o percentual de cada participante",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
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
                      Obx(
                        () => _TopDashboard(
                          processId: controller.processId,
                          processTitle: controller.processTitle,
                          totalPercentage: controller.totalPercentage,
                        ),
                      ),
                      const SizedBox(height: 16),


                      const _InfoBanners(),
                      const SizedBox(height: 24),

                      // 4. Container de Colaboradores
                      Container(
                        decoration: BoxDecoration(
                          color: bgLightBlue,
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "Defina o percentual de cada colaborador",
                                style: TextStyle(
                                  fontSize: 18,
                                   fontWeight: FontWeight.w700,
                                  color: textDark,
                                ),
                              ),
                            ),
                            const Divider(height: 1, color: Colors.blue),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (controller.shares.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Text("Nenhuma cota encontrada."),
                                  ),
                                );
                              }

                              // Filtramos a universidade pois ela já está no banner estático
                              final editableShares = controller.shares
                                  .where((s) => s.type != ShareType.university)
                                  .toList();

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: editableShares.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final share = editableShares[index];
                                  // Pegamos o index real no controller para os métodos funcionarem
                                  final realIndex = controller.shares.indexOf(
                                    share,
                                  );

                                  return _CollaboratorRow(
                                    share: share,
                                    onSliderChanged: (val) =>
                                        controller.updatePercentage(
                                          realIndex,
                                          val,
                                          fromText: false,
                                        ),
                                    onTextChanged: (val) =>
                                        controller.updatePercentage(
                                          realIndex,
                                          val,
                                          fromText: true,
                                        ),
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
              Obx(
                () => _BottomActionbar(
                  isValid: controller.isTotalValid,
                  isLoading: controller.isLoading.value,
                  onSubmit: controller.submit,
                ),
              ),
            ],
          ),
        ),
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
          ),
        ],
      ),

      child: IntrinsicHeight(
        child: Row(
          children: [
            // --- BLOCO 1: Informações do Processo (Esquerda) ---
            Expanded(
              flex: 3,
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
                    child: const Icon(
                      Icons.folder_outlined,
                      color: brandBlue,
                      size: 48,
                    ),
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

                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "Processo #$processId",
                              style: const TextStyle(
                                color: secondaryText,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: lightGreenBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                "Apto para distribuição de cotas",
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
            const VerticalDivider(
              color: dividerColor,
              width: 0,
              thickness: 2.0,
            ),

            // --- BLOCO 2: Gráfico Circular (Centro) ---
            Expanded(
              flex: 4,
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
            const VerticalDivider(
              color: dividerColor,
              width: 32,
              thickness: 1.5,
            ),

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
                    child: Divider(
                      height: 1,
                      color: dividerColor.withOpacity(0.6),
                    ),
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
  Widget _buildLegendRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
    Color bgColor,
  ) {
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
    const Color leftBorderColor = Color(
      0xFFB6D1FE,
    ); // Borda um pouco mais sutil
    const Color iconBgColor = Color(0xFFDBEAFE);
    const Color brandBlue = Color(0xFF2563EB); // Azul mais vibrante

    const Color rightBgColor = Color(0xFFFFEBEB);
    const Color rightBorderColor = Color(0xFFFFC5C5);

    const Color primaryText = Color(
      0xFF0F172A,
    ); // Quase preto, mais forte que o anterior
    const Color secondaryText = Color(0xFF64748B);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- BANNER ESQUERDO (Universidade) ---
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              // Mais respiro interno
              decoration: BoxDecoration(
                color: leftBgColor,
                border: Border.all(color: ThemeColor.primaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(6),
              ),

              child: Row(
                children: [
                  // 1. Ícone Universidade
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: brandBlue,
                      size: 48,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // 2. Texto Universidade e Badge FIXO
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ProcessRoyaltyDistributionController.unitinsName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: primaryText,
                          fontSize: 20,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: iconBgColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: brandBlue,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              "FIXO",
                              style: TextStyle(
                                color: brandBlue,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Altere o valor do 'width' (ex: 40, 60, 100) para fixar a distância exata entre os dois blocos.
                  const SizedBox(width: 100),
                  // 3. Ícone Escudo (Stack)
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.shield, color: brandBlue, size: 58),
                        Icon(Icons.lock, color: Colors.white, size: 25),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // 4. Textos da Porcentagem
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "70%",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Cota institucional protegida",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: primaryText,
                        ),
                      ),

                      SizedBox(height: 2),
                      Text(
                        "Esta participação é definida\npelas regras do processo",
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryText,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // --- BANNER DIREITO (Aviso) ---
          Expanded(
            flex: 4,
            child: Container(

              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
              ),
              child: Container(
                // MÁGICA 2: O filho não tem borderRadius, apenas a faixa lateral grossa.
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Color(0xFFEF4444), width: 5),
                  ),
                ),

                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.running_with_errors_sharp,
                        color: Color(0xFFEF4444),
                        size: 35,
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Atenção",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "A soma das cotas deve ser exatamente 100% para salvar a distribuição.",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
  final double maxLimit = 30.0;

  const _CollaboratorRow({
    super.key,
    required this.share,
    required this.onSliderChanged,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCreator = share.type == ShareType.creator;

    // Cores extraídas do Figma
    const Color brandBlue = Color(0xFF2563EB); // Azul principal dos botões
    const Color lightBlueBg = Color(0xFFEFF6FF); // Fundo claro dos badges
    const Color borderBlue = Color(0xFFBFDBFE); // Borda clara dos badges
    const Color dividerColor = Color(0xFFE2E8F0); // Linhas divisórias
    const Color textDark = Color(0xFF1E293B);
    const Color textLight = Color(0xFF64748B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dividerColor, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // --- 1. SEÇÃO DE PERFIL
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  // Avatar com dois tons de azul
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: lightBlueBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_circle,
                        color: brandBlue,
                        size: 79),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          share.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16.9,
                            color: textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Badge com borda
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: lightBlueBg,
                            border: Border.all(color: borderBlue),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isCreator ? "CRIADOR" : "MEMBRO",
                            style: const TextStyle(
                              color: brandBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const VerticalDivider(color: dividerColor, width: 32, thickness: 2),

            // --- 2. SEÇÃO DO SLIDER (Flex 5) ---
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Cota atribuída",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: textDark),
                  ),
                  const SizedBox(height: 5),

                  Obx(() {
                    final double maxLogicalLimit = isCreator ? 30.0 : 25.0;
                    return Column(
                      children: [

                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: brandBlue,
                            inactiveTrackColor: dividerColor,
                            thumbColor: brandBlue,
                            trackHeight: 10,
                            valueIndicatorColor: brandBlue,
                            valueIndicatorTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            showValueIndicator: ShowValueIndicator.always,
                            tickMarkShape: SliderTickMarkShape.noTickMark,
                          ),

                          child: Slider(
                            // Trava de segurança visual para a bolinha não passar do limite
                            value: share.percentage.value.clamp(share.minPercentage, maxLogicalLimit),

                            // A escala física universal da barra (sempre de 0 a 30)
                            min: 0.0,
                            max: 30.0,

                            // 300 divisões para permitir pulos suaves de 0.1%
                            divisions: 300,

                            // Balão flutuante inteligente (limpa o ".0" de números inteiros)
                            label: "${share.percentage.value.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '')}%",

                            // O "Guarda de Trânsito" das Regras de Negócio
                            onChanged: (newValue) {
                              if (newValue < share.minPercentage) {
                                onSliderChanged(share.minPercentage);
                              } else if (newValue > maxLogicalLimit) {
                                onSliderChanged(maxLogicalLimit);
                              } else {
                                onSliderChanged(newValue);
                              }
                            },
                          ),
                        ),
                        Padding(
                          // 14 é o valor mágico que compensa exatamente a margem interna do Slider nativo
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  "0%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isCreator ? Colors.transparent : textLight,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 32,
                                child: const Text("5%", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textLight)),
                              ),
                              SizedBox(
                                width: 32,
                                child: const Text("10%", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textLight)),
                              ),
                              SizedBox(
                                width: 32,
                                child: const Text("15%", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textLight)),
                              ),
                              SizedBox(
                                width: 32,
                                child: const Text("20%", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textLight)),
                              ),
                              SizedBox(
                                width: 32,
                                child: const Text("25%", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textLight)),
                              ),
                              SizedBox(
                                width: 32,
                                child: const Text("30%", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textLight)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),

                  // Badge do Criador
                  if (isCreator)
                    Container(
                      margin: const EdgeInsets.only(top: 6, left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: lightBlueBg,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Mínimo obrigatório criador",
                        style: TextStyle(
                          fontSize: 10,
                          color: brandBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const VerticalDivider(color: dividerColor, width: 32, thickness: 2),

            // --- 3. SEÇÃO DE INPUT (Flex 3) ---
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Stack para permitir que o Badge azul flutue ligeiramente por cima da borda
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      // Caixa Principal Integrada (Input + Botões Laterais)
                      Container(
                        width: 300, // Largura ideal para acomodar os botões e o texto confortavelmente
                        height: 50,  // Altura ligeiramente maior para melhor área de toque
                        margin: const EdgeInsets.only(top: 10), // Espaço para o badge flutuar em cima
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: dividerColor, width: 1.2),
                        ),
                        // ClipAntiAlias corta as quinas dos botões azuis para que obedeçam o borderRadius do Container pai
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            // Botão de Menos (-)
                            _SquareBtn(
                              icon: Icons.remove,
                              onPressed: () {
                                final newValue = share.percentage.value - 1;
                                if (newValue >= share.minPercentage) {
                                  onSliderChanged(newValue);
                                }
                              },
                            ),

                            // Campo de Texto de Entrada Integrado
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        // Vincula o controller reativo nativo do seu ShareFormModel
                                        controller: share.percentageController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: textDark,
                                        ),
                                        decoration: const InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: "Digite um valor",
                                          hintStyle: TextStyle(
                                            color: Color(0xFF94A3B8), // Tom cinza de placeholder do Figma
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                        onChanged: (text) {
                                          final percentage = double.tryParse(text.replaceAll(",", "."));
                                          if (percentage != null && percentage <= 30.0 && percentage >= share.minPercentage) {
                                            onTextChanged(percentage);
                                          }
                                        },
                                      ),
                                    ),
                                    const Text(
                                      "%",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Botão de Mais (+)
                            _SquareBtn(
                              icon: Icons.add,
                              onPressed: () {
                                final newValue = share.percentage.value + 1;
                                if (newValue <= 30.0) {
                                  onSliderChanged(newValue);
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // Badge Flutuante "Máximo: 30%" posicionado no topo
                      Positioned(
                        top: -35,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: brandBlue,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Text(
                            isCreator ? "Maximo: 30%" : "Maximo: 25%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}

// Botão Quadrado
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
        height: double.infinity, // Preenche toda a altura interna do container pai automaticamente
        color: const Color(0xFF1565C0), // Tom azul escuro idêntico aos botões do protótipo
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _BottomActionbar extends StatelessWidget {
  final bool isValid;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _BottomActionbar({
    required this.isValid,
    required this.isLoading,
    required this.onSubmit,
  });

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
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.green),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isValid ? "Distribuição completa" : "Distribuição pendente",
                    style: TextStyle(
                      color: isValid ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "Todas as cotas foram distribuídas.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0XFF004093),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: (isLoading || !isValid) ? null : onSubmit,
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save_outlined, color: Colors.white),
            label: Text(
              isLoading ? "Salvando..." : "Salvar distribuição",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
