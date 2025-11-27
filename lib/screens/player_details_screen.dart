// screens/player_details_screen.dart
import 'package:flutter/material.dart';
//wimport 'package:practica3/models/player.dart';
import 'package:practica3/providers/clash_provider.dart';
import 'package:provider/provider.dart';

class PlayerDetailsScreen extends StatelessWidget {
  const PlayerDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String playerTag =
        ModalRoute.of(context)!.settings.arguments as String;

    return ChangeNotifierProvider(
      create: (_) =>
          ClashProvider()..searchPlayer(playerTag.replaceFirst('#', '')),
      child: Consumer<ClashProvider>(
        builder: (context, provider, _) {
          final player = provider.searchedPlayer;
          final isLoading = provider.isLoading;

          if (isLoading) {
            return const Scaffold(
              backgroundColor: Colors.deepPurple,
              body: Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            );
          }

          if (player == null) {
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.deepPurple),
              backgroundColor: Colors.deepPurple,
              body: const Center(
                child: Text(
                  'Jugador no encontrado',
                  style: TextStyle(fontSize: 24, color: Colors.white70),
                ),
              ),
            );
          }

          // Cálculo del elixir medio del mazo actual
          final double avgElixir = player.currentDeck.isEmpty
              ? 0
              : player.currentDeck
                        .map((c) => c.elixirCost)
                        .reduce((a, b) => a + b) /
                    player.currentDeck.length;

          return Scaffold(
            backgroundColor: Colors.deepPurple,
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 400,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.deepPurple,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.deepPurple, Colors.purpleAccent],
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Escudo del clan (si tiene)
                              if (player.clan != null)
                                Image.network(
                                  'https://api-assets.clashroyale.com/badges/512/${player.clan!.badgeId}.png',
                                  width: 100,
                                  height: 100,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.shield,
                                    size: 100,
                                    color: Colors.white70,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              Text(
                                '${player.trophies} trofeos',
                                style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Nivel ${player.expLevel}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // INFO GENERAL
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (player.clan != null)
                          Card(
                            color: Colors.deepPurple.shade700,
                            child: ListTile(
                              leading: Image.network(
                                'https://api-assets.clashroyale.com/badges/512/${player.clan!.badgeId}.png',
                                width: 50,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.shield),
                              ),
                              title: Text(
                                player.clan!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                player.clan!.tag,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _StatCard(
                              label: 'Victorias',
                              value: '${player.wins}',
                            ),
                            _StatCard(
                              label: 'Derrotas',
                              value: '${player.losses}',
                            ),
                            _StatCard(
                              label: 'Ratio',
                              value:
                                  '${((player.wins / (player.wins + player.losses == 0 ? 1 : player.wins + player.losses)) * 100).toStringAsFixed(1)}%',
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                        const Text(
                          'Mazo Actual',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Elixir medio: ${avgElixir.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // MAZO EN GRID
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                          itemCount: player.currentDeck.length,
                          itemBuilder: (context, i) {
                            final card = player.currentDeck[i];
                            SizedBox(height: 10, width: 10);
                            return Column(
                              children: [
                                Image.network(
                                  card.iconUrl,
                                  width: 70,
                                  height: 70,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                ),
                                Text(
                                  'Nv.${card.level}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber,
                                  ),
                                ),
                                Text(
                                  '${card.elixirCost}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ],
                            );n
                          },
                        ),

                        const SizedBox(height: 40),
                        const Text(
                          'Carta Favorita',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Carta: ${avgElixir.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade700,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
