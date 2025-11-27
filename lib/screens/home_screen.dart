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
      appBar: AppBar(
        title: const Text('Clash Royale'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Top 10 players of every season + Cartas + Buscador')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Selector de temporada
          const SeasonSelector(),

          // 2. Swiper grande del Top 10 players de cada season
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
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  )
                : const PathOfLegendSwiper(),
          ),

          // 3. Slider de cartas + buscador (scrollable)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cartas del juego',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  CardsSlider(cards: clashProvider.allCards),
                  const SizedBox(height: 30),
                  const Text(
                    'Buscar jugador por tag',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
    );
  }
}