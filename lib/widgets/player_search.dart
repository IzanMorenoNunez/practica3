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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ej: L2P8Y9PC',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.amber),
                filled: true,
                fillColor: Colors.deepPurple.shade700,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabled: !clashProvider.isLoading,
              ),
              onSubmitted: (value) => _performSearch(context, controller.text.trim(), clashProvider),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: clashProvider.isLoading
                ? null
                : () => _performSearch(context, controller.text.trim(), clashProvider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: clashProvider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.deepPurple,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.arrow_forward, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }

  void _performSearch(BuildContext context, String input, ClashProvider provider) async {
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Introduce un tag')),
      );
      return;
    }
    String cleanTag = input.trim().toUpperCase();
    if (!cleanTag.startsWith('#')) {
      cleanTag = '#$cleanTag';
    }
    Navigator.pushNamed(
      context,
      'player_details',
      arguments: cleanTag,
    );
    // controller.clear();
  }
}