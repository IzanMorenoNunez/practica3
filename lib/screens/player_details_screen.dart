// screens/player_details_screen.dart
import 'package:flutter/material.dart';
import 'package:practica3/models/card.dart';
import 'package:practica3/providers/clash_provider.dart';
import 'package:provider/provider.dart';

class PlayerDetailsScreen extends StatelessWidget {
  const PlayerDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String playerTag = ModalRoute.of(context)!.settings.arguments as String;

    return ChangeNotifierProvider(
      create: (_) => ClashProvider()..searchPlayer(playerTag.replaceFirst('#', '')),
      child: Consumer<ClashProvider>(
        builder: (context, provider, _) {
          final player = provider.searchedPlayer;
          final isLoading = provider.isLoading;

          if (isLoading) {
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(child: CircularProgressIndicator(color: Colors.amber)),
                ),
              ),
            );
          }

          if (player == null) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: Text(
                      'Jugador no encontrado',
                      style: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  ),
                ),
              ),
            );
          }

          final double avgElixir = player.currentDeck.isEmpty
              ? 0
              : player.currentDeck.map((c) => c.elixirCost).reduce((a, b) => a + b) / player.currentDeck.length;

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 6, 0, 90),           // Azul oscuro arriba
                      Color.fromARGB(240, 6, 0, 90),
                      Colors.transparent,                     // Fade hacia la imagen
                      Colors.black87,                          // Oscuro abajo
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 380,
                        floating: false,
                        pinned: true,
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (player.clan != null)
                                  Container(
                                    child: Image.network(
                                      'https://api-assets.clashroyale.com/badges/512/${player.clan!.badgeId}.png',
                                      width: 130,
                                      height: 130,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.shield, size: 130, color: Colors.white70),
                                    ),
                                  ),
                                const SizedBox(height: 24),
                                Text(
                                  '${player.trophies}',
                                  style: const TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                    shadows: [
                                      Shadow(color: Colors.black87, blurRadius: 20, offset: Offset(0, 6)),
                                    ],
                                  ),
                                ),
                                const Text('trofeos', style: TextStyle(fontSize: 22, color: Colors.white70)),
                                const SizedBox(height: 12),
                                Text(
                                  'Nivel ${player.expLevel}',
                                  style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              if (player.clan != null)
                                Card(
                                  color: Colors.blue.shade900.withOpacity(0.95),
                                  child: ListTile(
                                    leading: Image.network(
                                      'https://api-assets.clashroyale.com/badges/512/${player.clan!.badgeId}.png',
                                      width: 50,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.shield),
                                    ),
                                    title: Text(player.clan!.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                    subtitle: Text(player.clan!.tag, style: const TextStyle(color: Colors.white70)),
                                  ),
                                ),

                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _StatCard(label: 'Victorias', value: '${player.wins}'),
                                  _StatCard(label: 'Derrotas', value: '${player.losses}'),
                                  _StatCard(
                                    label: 'Ratio',
                                    value: '${((player.wins / (player.wins + player.losses == 0 ? 1 : player.wins + player.losses)) * 100).toStringAsFixed(1)}%',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 40),
                              const Text('Mazo Actual', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
                              const SizedBox(height: 10),
                              Text('Elixir medio: ${avgElixir.toStringAsFixed(1)}', style: const TextStyle(fontSize: 18, color: Colors.white70)),
                              const SizedBox(height: 20),

                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 0.6,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                ),
                                itemCount: player.currentDeck.length,
                                itemBuilder: (context, i) {
                                  final deckCard = player.currentDeck[i];
                                  final fullCard = provider.allCards.firstWhere(
                                    (c) => c.name == deckCard.name,
                                    orElse: () => ClashCard(
                                      id: 0,
                                      name: deckCard.name,
                                      elixirCost: deckCard.elixirCost,
                                      rarity: 'unknown',
                                      mediumIcon: deckCard.iconUrl,
                                      maxLevel: 14,
                                      evolutionIcon: null,
                                    ),
                                  );
                                  return GestureDetector(
                                    onTap: () => _showCardDetail(context, fullCard, deckCard.level),
                                    child: Card(
                                      color: Colors.blue.shade800.withOpacity(0.95),
                                      elevation: 12,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.network(deckCard.iconUrl, width: 64, height: 64),
                                          const SizedBox(height: 6),
                                          Text('Nv.${deckCard.level}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber)),
                                          Text('${deckCard.elixirCost}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyan)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 40),
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
        },
      ),
    );
  }

  void _showCardDetail(BuildContext context, ClashCard card, int currentLevel) {
    final colorByRarity = {
      'common': Colors.grey.shade400,
      'rare': Colors.green,
      'epic': Colors.purple,
      'legendary': Colors.orange,
      'champion': Colors.cyan,
    };
    final rarityColor = colorByRarity[card.rarity] ?? Colors.grey;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar detalle de carta",
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0033),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.amber, width: 3),
                boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 30, spreadRadius: 6)],
              ),
              child: Material(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 34),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.network(card.mediumIcon, height: 220, fit: BoxFit.contain)),
                      const SizedBox(height: 20),
                      if (card.evolutionIcon != null) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.2), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orange, width: 2)),
                          child: Column(children: [
                            const Text('EVOLUCIÓN', style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Image.network(card.evolutionIcon!, height: 160, fit: BoxFit.contain),
                          ]),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(card.name, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: rarityColor, size: 40),
                          const SizedBox(width: 12),
                          Text(card.rarity.toUpperCase(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: rarityColor)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        children: [
                          _DetailChip(icon: Icons.bolt, label: '${card.elixirCost} Elixir', color: Colors.cyan),
                          _DetailChip(icon: Icons.shield, label: 'Máx: ${card.maxLevel ?? 14}', color: Colors.amber),
                          _DetailChip(icon: Icons.person, label: 'Nivel: $currentLevel', color: Colors.green),
                          if (card.evolutionIcon != null) _DetailChip(icon: Icons.auto_awesome, label: 'Evolucionable', color: Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
      color: Colors.blue.shade900.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 24, color: Colors.amber, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _DetailChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide(color: color, width: 2),
      avatar: Icon(icon, color: color, size: 20),
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}