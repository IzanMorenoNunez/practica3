// screens/player_details_screen.dart
import 'package:flutter/material.dart';
import 'package:practica3/providers/clash_provider.dart';
import 'package:provider/provider.dart';

class PlayerDetailsScreen extends StatelessWidget {
  const PlayerDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<ClashProvider>(context).searchedPlayer!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(player.name),
              background: Container(color: Colors.deepPurple),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(title: Text('Trofeos'), trailing: Text('${player.trophies}')),
              ListTile(title: Text('Victorias'), trailing: Text('${player.wins}')),
              ListTile(title: Text('Derrotas'), trailing: Text('${player.losses}')),
              ListTile(title: Text('Arena'), trailing: Text(player.arena)),
              // Puedes añadir más...
            ]),
          ),
        ],
      ),
    );
  }
}