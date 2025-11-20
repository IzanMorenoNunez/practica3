// widgets/player_search.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clash_provider.dart';

class PlayerSearch extends StatelessWidget {
  const PlayerSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clashProvider = Provider.of<ClashProvider>(context);
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Ej: #LPYGCLCGJ',
                labelText: 'Buscar jugador por tag',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: clashProvider.isLoading
                ? null
                : () async {
                    await clashProvider.searchPlayer(controller.text.trim());
                    if (clashProvider.searchedPlayer != null) {
                      Navigator.pushNamed(context, 'player_details');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jugador no encontrado')),
                      );
                    }
                  },
            child: clashProvider.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}