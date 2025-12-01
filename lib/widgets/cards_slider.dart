// widgets/cards_slider.dart
import 'package:flutter/material.dart';
import '../models/card.dart';

class CardsSlider extends StatelessWidget {
  final List<ClashCard> cards;
  const CardsSlider({Key? key, required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (_, i) {
          final card = cards[i];

          return GestureDetector(
            onTap: () => _showCardDetail(context, card),
            child: Container(
              width: 130,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade800,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: FadeInImage(
                      placeholder: const AssetImage('assets/no-image.jpg'),
                      image: NetworkImage(card.mediumIcon),
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: [
                        Text(
                          card.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${card.elixirCost}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCardDetail(BuildContext context, ClashCard card) {
    final colorByRarity = {
      'common': Colors.grey.shade400,
      'rare': Colors.green,
      'epic': Colors.purple,
      'legendary': Colors.orange,
      'champion': Colors.cyan,
    };
    final rarityColor = colorByRarity[card.rarity] ?? Colors.white70;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.85),
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
                boxShadow: [
                  BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 30, spreadRadius: 6),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Cerrar
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 34),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      // Imagen principal
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(card.mediumIcon, height: 220, fit: BoxFit.contain),
                      ),

                      const SizedBox(height: 20),

                      // Evolución si tiene
                      if (card.evolutionIcon != null) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.orange, width: 2),
                          ),
                          child: Column(
                            children: [
                              const Text('EVOLUCIÓN', style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Image.network(card.evolutionIcon!, height: 160, fit: BoxFit.contain),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Nombre
                      Text(
                        card.name,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Rarity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: rarityColor, size: 40),
                          const SizedBox(width: 12),
                          Text(
                            card.rarity.toUpperCase(),
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: rarityColor),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Chips
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        children: [
                          _DetailChip(icon: Icons.bolt, label: '${card.elixirCost} Elixir', color: Colors.cyan),
                          _DetailChip(icon: Icons.shield, label: 'Máx: ${card.maxLevel ?? 14}', color: Colors.amber),
                          if (card.evolutionIcon != null)
                            _DetailChip(icon: Icons.auto_awesome, label: 'Evolucionable', color: Colors.orange),
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
      avatar: Icon(icon, color: color, size: 22),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}