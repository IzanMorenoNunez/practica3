// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clash_provider.dart';
import '../widgets/tournament_swiper.dart';
import '../widgets/cards_slider.dart';
import '../widgets/player_search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clashProvider = Provider.of<ClashProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clash Royale'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. SWIPER GRANDE: Torneos Globales
            TournamentSwiper(tournaments: clashProvider.globalTournaments),

            const SizedBox(height: 20),

            // 2. SLIDER: Todas las cartas
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Cartas del juego', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            CardsSlider(cards: clashProvider.allCards),

            const SizedBox(height: 30),

            // 3. BUSCADOR DE JUGADOR
            const PlayerSearch(),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}