// widgets/cards_slider.dart
import 'package:flutter/material.dart';
import '../models/card.dart';

class CardsSlider extends StatelessWidget {
  final List<ClashCard> cards;
  const CardsSlider({Key? key, required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cards.length,
        itemBuilder: (_, i) {
          final card = cards[i];

          return GestureDetector(
            onTap: () => _showCardDetail(context, card),
            child: Container(
              width: 140,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 20, 1, 185),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.amber.shade700, width: 3),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        card.mediumIcon,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(21)),
                    ),
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
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${card.elixirCost}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
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
      barrierLabel: 'Cerrar detalle de carta',
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
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70, size: 34),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(card.mediumIcon, height: 220, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 20),
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
                      Text(
                        card.name,
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
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
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        alignment: WrapAlignment.center,
                        children: [
                          _DetailChip(icon: Icons.bolt, label: '${card.elixirCost} Elixir', color: const Color.fromARGB(255, 194, 0, 212)),
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
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}