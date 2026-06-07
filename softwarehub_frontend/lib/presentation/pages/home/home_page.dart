import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nit_sgpi_frontend/presentation/pages/home/widgets/process%20card.dart';
import 'package:nit_sgpi_frontend/presentation/shared/theme/theme_color.dart';
import 'package:nit_sgpi_frontend/presentation/shared/utils/responsive.dart';
import 'package:nit_sgpi_frontend/infra/datasources/auth_local_datasource.dart';
import 'controllers/home_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nit_sgpi_frontend/presentation/shared/widgets/shared_background.dart';
import 'widgets/footer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final processController = Get.find<ProcessController>();
  final authLocalDataSource = Get.find<AuthLocalDataSource>();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
   
    final theme = Theme.of(context);

    Color getStatusColor(String status) {
      switch (status) {
        case "PENDENTE_DISTRIBUICAO_COTAS":
          return const Color.fromARGB(255, 228, 206, 11);

        case "COTAS_DISTRIBUIDAS":
          return Colors.blue;

        case "CORRECAO":
          return Colors.red;

        case "CORRIGIDO":
          return Colors.orange;

        case "CLASSIFICADO":
          return Colors.purple;

        case "FINALIZADO":
          return Colors.green;

        case "INATIVO":
          return Colors.grey;

        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFCBD5E1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: theme.colorScheme.primary,
              elevation: 10,
              surfaceTintColor: Colors.transparent,
              toolbarHeight: 90,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              titleSpacing: 24,
              title: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/logo_sgpi.svg",
                    width: 60,
                    height: 65,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Bem-Vindo ",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w300,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.6,
                                  ),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: "Software",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.9,
                                  ),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: "Hub",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 30,
                                  color: const Color(0xFFFDAA51),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                FutureBuilder<String?>(
                  future: authLocalDataSource.getRole(),
                  builder: (context, snapshot) {
                    final isAdmin = snapshot.data == 'ADMIN';
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(
                                0.08,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.2,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              isAdmin ? "ADMIN" : "USUÁRIO",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {
                              Get.toNamed("/user-logged");
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(40, 40),
                            ),
                            icon: const Icon(Icons.person, size: 45),
                          ),
                          const SizedBox(width: 18.5),
                          Container(
                            height: 70,
                            width: 1.6,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 13),
                          TextButton.icon(
                            onPressed: () {
                              authLocalDataSource.clear();
                              Get.offAllNamed("/login");
                            },
                            icon: Icon(
                              Icons.logout_rounded,
                              color: theme.colorScheme.primary,
                              size: 36,
                            ),
                            label: Text(
                              "Sair",
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 19,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
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
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: UnifiedBackgroundPainter(
                color: theme.colorScheme.primary.withOpacity(0.08),
                icon: Icons.rocket_launch_outlined,
              ),
            ),
          ),
          Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            interactive: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: Responsive.getPadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(33),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.40),
                            blurRadius: 8,
                            offset: const Offset(0, 9),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Painel de Processos",
                                      style: theme.textTheme.headlineLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -0.5,
                                            color: Colors.black87,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Sistema de Gestão de Propriedade Intelectual",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontSize: 17,
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Get.toNamed("/process");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.add, size: 22),
                                    SizedBox(width: 6),
                                    Text(
                                      "NOVO PROCESSO",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Obx(() {
                              if (processController
                                  .isLoadingProcessCount
                                  .value) {
                                return const CircularProgressIndicator();
                              }
                              if (processController.processesStatus.isEmpty) {
                                return const Text("Nenhum dado encontrado");
                              }
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: processController.processesStatus.map(
                                  (item) {
                                
                                    final color = getStatusColor(item.status);

                                    return Container(
                                      height: 55,
                                      width: 260,
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        right: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: color,
                                          width: 1.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.15,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.statusLabel,
                                              style: const TextStyle(
                                                decorationColor:
                                                    ThemeColor.greyColor,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              item.amount.toString().padLeft(
                                                2,
                                                '0',
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),
                          const FilterHeader(),
                          const SizedBox(height: 24),
                          Obx(() {
                            final list = processController.processes.toList();
                            if (processController.isLoadingList.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (list.isEmpty) {
                              return Center(
                                child: Text(
                                  "Sem resultados!",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    spacing: 20,
                                    runSpacing: 20,
                                    children: list
                                        .map((item) => ProcessCard(item: item))
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Obx(() {
                                  final current =
                                      processController.currentPage.value;
                                  final total =
                                      processController.totalPages.value;
                                  if (total <= 1) return const SizedBox();
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: current > 0
                                            ? processController.previousPage
                                            : null,
                                        child: Text(
                                          "Anterior",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        "Página ${current + 1} de $total",
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: current < total - 1
                                            ? processController.nextPage
                                            : null,
                                        child: Text(
                                          "Próxima",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Footer(),
                    const SizedBox(height: 24),
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

class FilterHeader extends StatefulWidget {
  const FilterHeader({super.key});

  @override
  State<FilterHeader> createState() => _FilterHeaderState();
}

class _FilterHeaderState extends State<FilterHeader> {
  final List<String> filters = [
    "Todos",
    "Aguardando distribuição de cotas",
    "Cotas distribuídas",
    "Em correção",
    "Corrigido",
    "Classificado",
    "Finalizado",
  ];
  int selectedIndex = 0;

  final TextEditingController controller = TextEditingController();
  final processController = Get.find<ProcessController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    return SizedBox(
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _title(context),
                const SizedBox(height: 12),
                _buildFilters(context),
                const SizedBox(height: 12),
                _buildSearch(context, controller),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title(context),
                      const SizedBox(height: 12),
                      _buildFilters(context),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(width: 280, child: _buildSearch(context, controller)),
              ],
            ),
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Visão Geral",
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Filtre pelo status do seu processo",
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Wrap(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          final isFirst = index == 0;
          final isLast = index == filters.length - 1;

          BorderRadius radius;
          if (isFirst) {
            radius = const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            );
          } else if (isLast) {
            radius = const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            );
          } else {
            radius = BorderRadius.zero;
          }

          return InkWell(
            borderRadius: radius,
            onTap: () {
              setState(() => selectedIndex = index);
              final statusMap = {
                0: "",
                1: "PENDENTE_DISTRIBUICAO_COTAS",
                2: "COTAS_DISTRIBUIDAS",
                3: "CORRECAO",
                4: "CORRIGIDO",
                5: "CLASSIFICADO",
                6: "FINALIZADO"
              };
              processController.filterByStatus(statusMap[index]!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
                borderRadius: radius,
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearch(BuildContext context, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: "Pesquisar...",
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
        prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
        ),
      ),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) => processController.searchByTitle(value),
    );
  }
}
