import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/models.dart';

class ClashProvider extends ChangeNotifier {
  //final String _baseUrl = 'api.clashroyale.com';

  List<PathOfLegendPlayer> pathOfLegendPlayers = [];
  String selectedSeason = '2025-10'; //temporada per defecte
  List<ClashCard> allCards = [];
  ClashPlayer? searchedPlayer;
  bool isLoading = false;

  ClashProvider() {
    initData();
  }

  Future<void> initData() async {
    await Future.wait([getPathOfLegendTopPlayers(), getAllCards()]);
  }

  Future<String> _get(
    String endpoint, {
    Map<String, String> queryParameters = const {},
  }) async {
    final url = Uri.https('api.clashroyale.com', endpoint, queryParameters);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjIzYjNkMGU0LWY3NjItNGE0Yy1hZWRiLWJhZmRiMjZjNGYzYyIsImlhdCI6MTc2NDA1Njc5MCwic3ViIjoiZGV2ZWxvcGVyL2I3YjRjNTRiLTdlMGQtYzJiNS03MjVjLWY0Y2RmZWZhZWQ4NCIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyI0NS4xNDQuMTIuNDIiXSwidHlwZSI6ImNsaWVudCJ9XX0.wGZegMU2ViGYm9DnenpY14KSB2w7kIOjWDk8YU-iU43CioaPYXNud0Ke1DehXkYy2orICO-asKgWMUIyBdoMLQ',
        'Accept': 'application/json',
        'User-Agent': 'Flutter App',
      },
    ).timeout(const Duration(seconds: 15));

    print('URL: $url');
    print('Status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
    return response.body;
  }

  Future<void> getPathOfLegendTopPlayers([String? season]) async {
    season ??= selectedSeason;

    final jsonData = await _get(
      '/v1/locations/global/pathoflegend/$season/rankings/players',
      queryParameters: {'limit': '10'},
    );

    final List<dynamic> items = json.decode(jsonData)['items'];
    pathOfLegendPlayers = items.map((j) => PathOfLegendPlayer.fromJson(j)).toList();
    notifyListeners();
  }

  Future<void> getAllCards() async {
    final jsonData = await _get('/v1/cards');
    final List<dynamic> items = json.decode(jsonData)['items'];
    allCards = items.map((c) => ClashCard.fromJson(c)).toList();
    notifyListeners();
  }

  Future<void> searchPlayer(String tag) async {
    if (!tag.startsWith('#')) tag = '#$tag';
    final encodedTag = tag.replaceAll('#', '%23').toUpperCase();
  
    isLoading = true;
    notifyListeners();
  
    try {
      final jsonData = await _get('/v1/players/$encodedTag');
      searchedPlayer = ClashPlayer.fromJson(json.decode(jsonData));
    } catch (e) {
      searchedPlayer = null;
    }
  
    isLoading = false;
    notifyListeners();
  }
}
