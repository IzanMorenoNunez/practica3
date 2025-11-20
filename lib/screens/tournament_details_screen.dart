import 'package:flutter/material.dart';
import '../models/tournament.dart';

class TournamentDetailsScreen extends StatelessWidget {
  const TournamentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recogemos el torneo que se pasó como argumento
    final GlobalTournament tournament =
        ModalRoute.of(context)!.settings.arguments as GlobalTournament;

    // Formateo bonito de fechas
    final start = _formatDate(tournament.startTime);
    final end = _formatDate(tournament.endTime);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar grande con fondo
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                tournament.title,
                style: const TextStyle(fontSize: 18, shadows: [
                  Shadow(blurRadius: 10, color: Colors.black54),
                ]),
                textAlign: TextAlign.center,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Fondo (puedes cambiar por una imagen chula de Clash)
                  Image.asset(
                    'assets/tournament_bg.jpg', // opcional
                    fit: BoxFit.cover,
                    color: Colors.black45,
                    colorBlendMode: BlendMode.darken,
                  ),
                  Container(color: Colors.black38),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 80,
                          color: tournament.isActive ? Colors.yellow : Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          tournament.isActive ? 'TORNEO EN CURSO' : 'TORNEO FINALIZADO',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: tournament.isActive ? Colors.yellow : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenido
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),

                // Estado rápido
                _InfoRow(
                  icon: Icons.timer,
                  label: 'Estado',
                  value: tournament.isActive ? 'Activo' : 'Finalizado',
                  color: tournament.isActive ? Colors.green : Colors.red,
                ),

                _InfoRow(
                  icon: Icons.close,
                  label: 'Pérdidas máximas',
                  value: tournament.maxLosses == 999 ? 'Ilimitadas' : '${tournament.maxLosses}',
                ),

                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Comienza',
                  value: start,
                ),

                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Termina',
                  value: end,
                ),

                _InfoRow(
                  icon: Icons.tag,
                  label: 'Tag',
                  value: tournament.tag,
                ),

                const SizedBox(height: 30),

                // Botón grande para copiar el tag (muy útil)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Aquí podrías usar clipboard si añades el paquete clipboard
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tag copiado: ${tournament.tag}')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar tag del torneo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} UTC';
  }
}

// Widget reutilizable para cada fila de info
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.deepPurple),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: color != null
          ? Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            )
          : null,
    );
  }
}