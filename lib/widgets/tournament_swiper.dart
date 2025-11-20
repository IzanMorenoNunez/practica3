// widgets/tournament_swiper.dart
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../models/tournament.dart';

class TournamentSwiper extends StatelessWidget {
  final List<GlobalTournament> tournaments;

  const TournamentSwiper({Key? key, required this.tournaments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (tournaments.isEmpty) {
      return SizedBox(
        height: size.height * 0.5,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      height: size.height * 0.5,
      child: Swiper(
        itemCount: tournaments.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.7,
        itemHeight: size.height * 0.4,
        itemBuilder: (_, index) {
          final tournament = tournaments[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'tournament_details', arguments: tournament),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.deepPurple,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const Opacity(
                      opacity: 0.7,
                      child: Image(image: AssetImage('assets/tournament_bg.jpg'), fit: BoxFit.cover),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(tournament.title, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                          Text(tournament.status, style: const TextStyle(fontSize: 18, color: Colors.yellow)),
                          Text('Pérdidas máx: ${tournament.maxLosses}', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}