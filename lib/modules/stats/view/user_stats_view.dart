import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamemate/modules/stats/controller/user_stats_controller.dart';
import 'package:get/get.dart';
import 'package:gamemate/widgets/bottom_navigation.dart';

class UserStatsView extends GetView<UserStatsController> {
  const UserStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: const Color(0xFF001F3F),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text(
              'Erro: ${controller.error.value}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }

        final stats = controller.stats.value;
        if (stats == null) {
          return const Center(
            child: Text('Sem dados disponíveis', style: TextStyle(color: Colors.white)),
          );
        }

        if (stats.overall.totalGames == 0) {
          return _buildEmptyState();
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF040F1A), Color(0xFF001F3F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Estatísticas',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          StatsBox(
                            title: 'Geral',
                            iconPath: null,
                            items: {
                              'Jogos:': stats.overall.totalGames.toString(),
                              'Platinados:': _sumFromProviders(stats, 'PLATINADO').toString(),
                              'Conquistas:': _sumFromProviders(stats, 'CONQUISTAS').toString(),
                              'Horas jogadas:': '${stats.overall.totalHoursPlayed.toStringAsFixed(1)}h',
                            },
                          ),
                          const SizedBox(height: 16),

                          if (stats.byProvider.containsKey('GAMEMATE'))
                            StatsBox(
                              title: 'GameMate',
                              iconPath: 'assets/platforms/gamemate-stats.svg',
                              items: {
                                'Jogos:': stats.byProvider['GAMEMATE']!.totalGames.toString(),
                                'Platinados:': stats.byProvider['GAMEMATE']!.gamesByStatus['PLATINADO']?.toString() ?? '-',
                                'Conquistas:': stats.byProvider['GAMEMATE']!.gamesByStatus['CONQUISTAS']?.toString() ?? '-',
                                'Horas jogadas:': '${stats.byProvider['GAMEMATE']!.totalHoursPlayed.toStringAsFixed(1)}h',
                              },
                            ),
                          if (stats.byProvider.containsKey('GAMEMATE')) const SizedBox(height: 16),

                          if (stats.byProvider.containsKey('STEAM'))
                            StatsBox(
                              title: 'Steam',
                              iconPath: 'assets/platforms/steam.svg',
                              items: {
                                'Jogos:': stats.byProvider['STEAM']!.totalGames.toString(),
                                'Platinados:': stats.byProvider['STEAM']!.gamesByStatus['PLATINADO']?.toString() ?? '-',
                                'Conquistas:': stats.byProvider['STEAM']!.gamesByStatus['CONQUISTAS']?.toString() ?? '-',
                                'Horas jogadas:': '${stats.byProvider['STEAM']!.totalHoursPlayed.toStringAsFixed(1)}h',
                              },
                            ),
                          if (stats.byProvider.containsKey('STEAM')) const SizedBox(height: 16),

                          if (stats.byProvider.containsKey('GOG'))
                            StatsBox(
                              title: 'GOG',
                              iconPath: 'assets/platforms/gog-stats.svg',
                              items: {
                                'Jogos:': stats.byProvider['GOG']!.totalGames.toString(),
                                'Platinados:': stats.byProvider['GOG']!.gamesByStatus['PLATINADO']?.toString() ?? '-',
                                'Conquistas:': stats.byProvider['GOG']!.gamesByStatus['CONQUISTAS']?.toString() ?? '-',
                                'Horas jogadas:': '${stats.byProvider['GOG']!.totalHoursPlayed.toStringAsFixed(1)}h',
                              },
                            ),

                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xFF001F3F)),
        child: const CustomBottomBar(),
      ),
    );
  }

  static int _sumFromProviders(stats, String key) {
    int sum = 0;
    stats.byProvider.forEach((_, provider) {
      final value = provider.gamesByStatus[key];
      if (value != null) {
        sum += (value as num).toInt();
      }
    });
    return sum;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/Sleep.svg', width: 80, height: 80),
            const SizedBox(height: 24),
            const Text(
              'OPS!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2284E6),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Você ainda não tem nada para mostrar.\nAdicione alguns jogos ou vincule suas contas para ter algo para mostrar!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF2284E6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsBox extends StatelessWidget {
  final String title;
  final String? iconPath;
  final Map<String, String> items;

  const StatsBox({
    Key? key,
    required this.title,
    this.iconPath,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF001F3F),
        border: Border.all(color: const Color(0xFF2284E6), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconPath != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SvgPicture.asset(iconPath!, width: 28, height: 28),
                ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: const TextStyle(color: Colors.white, fontSize: 15)),
                  Text(
                    e.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
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
