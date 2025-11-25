
import 'package:flutter/material.dart';
import 'package:practica3/providers/clash_provider.dart';
import 'package:provider/provider.dart';

class SeasonSelector extends StatelessWidget {
  const SeasonSelector({Key? key}) : super(key: key);

  // Lista limpia y sin duplicados de 2016 hasta 2025-10
  static final List<String> seasons = List.generate(10, (y) => 2016 + y)
      .expand((year) => List.generate(12, (m) => '$year-${(m + 1).toString().padLeft(2, '0')}'))
      .toList()
      .reversed
      .takeWhile((s) => s.compareTo('2025-10') <= 0)
      .toList()
      .reversed
      .toList();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClashProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue text) {
          if (text.text.isEmpty) return seasons;
          return seasons.where((s) => s.contains(text.text));
        },
        onSelected: (season) {
          provider.selectedSeason = season;
          provider.getPathOfLegendTopPlayers(season);
        },
        fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
          controller.text = provider.selectedSeason;
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today, color: Colors.amber),
              labelText: 'Temporada (ej: 2025-10)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.deepPurple.shade50,
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                width: 300,
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(options.elementAt(i)),
                    onTap: () => onSelected(options.elementAt(i)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}