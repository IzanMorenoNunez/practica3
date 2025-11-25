import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/clash_provider.dart';
import 'screens/home_screen.dart';
import 'screens/player_details_screen.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClashProvider()..initData(), lazy: false),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clash Royale App',
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreen(),
        'player_details': (_) => const PlayerDetailsScreen(),
      },
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(color: Colors.deepPurple, elevation: 0),
      ),
    );
  }
}