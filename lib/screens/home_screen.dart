// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:practica3/providers/clash_provider.dart';
import 'package:practica3/widgets/cards_slider.dart';
import 'package:practica3/widgets/path_of_legend_swiper.dart';
import 'package:practica3/widgets/player_search.dart';
import 'package:practica3/widgets/season_selector.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clashProvider = Provider.of<ClashProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          style: TextStyle(color: Colors.white),
          'Clash Royale',
        ),
        backgroundColor: const Color.fromARGB(255, 1, 58, 216).withOpacity(0.9),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Top 10 players of every season + Cartas + Buscador',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: SafeArea(
            child: Column(
              children: [
                const SeasonSelector(),
                Expanded(
                  child: clashProvider.pathOfLegendPlayers.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.amber),
                              SizedBox(height: 20),
                              Text(
                                'Cargando Top 10 Path of Legends...',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const PathOfLegendSwiper(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cartas del juego',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CardsSlider(cards: clashProvider.allCards),
                        const SizedBox(height: 30),
                        const Text(
                          'Buscar jugador por tag',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const PlayerSearch(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
