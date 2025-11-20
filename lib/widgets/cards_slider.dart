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
          return Container(
            width: 130,
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(card.mediumIcon),
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(card.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                Text('Elixir: ${card.elixirCost}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}