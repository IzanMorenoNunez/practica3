import 'package:flutter/material.dart';
import 'package:practica3/providers/clash_provider.dart';
import 'package:provider/provider.dart';

class SeasonSelector extends StatelessWidget {
  const SeasonSelector({Key? key}) : super(key: key);

  // Lista de temporadas válidas (desde 2016 hasta 2025-10)
  static final List<String> seasons = List.generate(10, (y) => 2023 + y)
      .expand(
        (year) => List.generate(
          12,
          (m) => '$year-${(m + 1).toString().padLeft(2, '0')}',
        ),
      )
      .where((s) => s.compareTo('2025-10') <= 0)
      .toList()
      .reversed
      .toList();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClashProvider>(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 17, 170),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.amber, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: provider.selectedSeason,
          dropdownColor: const Color.fromARGB(255, 102, 92, 92),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.amber),
          isExpanded: true,
          hint: const Text(
            'Selecciona temporada',
            style: TextStyle(color: Colors.white70),
          ),
          items: seasons.map((season) {
            return DropdownMenuItem(
              value: season,
              child: Text(
                season,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }).toList(),
          onChanged: (newSeason) {
            if (newSeason != null) {
              provider.selectedSeason = newSeason;
              provider.getPathOfLegendTopPlayers(newSeason);
            }
          },
        ),
      ),
    );
  }
}
