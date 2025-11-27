import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:practica3/providers/clash_provider.dart';
import 'package:provider/provider.dart';

class PathOfLegendSwiper extends StatelessWidget {
  const PathOfLegendSwiper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<ClashProvider>(context).pathOfLegendPlayers;
    final size = MediaQuery.of(context).size;

    if (players.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    return Swiper(
      itemCount: players.length,
      layout: SwiperLayout.STACK,
      itemWidth: size.width * 0.82,
      itemHeight: size.height * 0.48,
      itemBuilder: (context, index) {
        final p = players[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, 'player_details', arguments: p.tag);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Ranking grande arriba a la derecha
                Positioned(
                  top: 16,
                  right: 16,
                  child: Text(
                    '#${p.rank}',
                    style: const TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                    ),
                  ),
                ),

                // Contenido principal
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 20), // ← margen inferior generoso
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Espacio superior para el ranking
                      const SizedBox(height: 60),

                      // Nombre del jugador (con clip para evitar overflow)
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'ELO: ${p.eloRating}',
                        style: const TextStyle(fontSize: 24, color: Colors.amber),
                      ),

                      const SizedBox(height: 16),

                      // Clan (opcional)
                      if (p.clanName != null)
                        Row(
                          children: [
                            Image.network(
                              'https://api-assets.clashroyale.com/badges/512/${p.clanBadgeId}.png',
                              width: 48,
                              height: 48,
                              errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white70, size: 48),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                p.clanName!,
                                style: const TextStyle(fontSize: 18, color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}