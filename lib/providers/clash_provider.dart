import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/models.dart';

class ClashProvider extends ChangeNotifier {
  final String _baseUrl = 'api.clashroyale.com';
  
  List<GlobalTournament> globalTournaments = [];
  List<ClashCard> allCards = [];
  ClashPlayer? searchedPlayer;
  bool isLoading = false;

  ClashProvider() {
    initData();
  }

  Future<void> initData() async {
    await Future.wait([
      getGlobalTournaments(),
      getAllCards(),
    ]);
  }

  Future<String> _get(String endpoint) async {
    final url = Uri.https(_baseUrl, endpoint);
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImQ0MTExMDhkLTlmNGUtNDIzZi04MmMxLWFjZjJhNWNjN2QzNCIsImlhdCI6MTc2MzYzMzU0Mywic3ViIjoiZGV2ZWxvcGVyL2I3YjRjNTRiLTdlMGQtYzJiNS03MjVjLWY0Y2RmZWZhZWQ4NCIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyI3Ny4yMjAuMjAwLjE2NCJdLCJ0eXBlIjoiY2xpZW50In1dfQ.0lF3R5-55tYAJOQgZakpesYLBkYMlbuue1251CiPORZnZ8S4cHzRDHvg4rbq9Ugp7aRulakHw_JW0CxwWzQoNA',
    });

    if (response.statusCode != 200) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error ${response.statusCode}');
    }
    return response.body;
  }

  Future<void> getGlobalTournaments() async {
    final jsonData = await _get('/v1/globaltournaments');
    final List<dynamic> items = json.decode(jsonData)['items'];
    globalTournaments = items
        .map((t) => GlobalTournament.fromJson(t))
        .where((t) => t.isActive)
        .toList();
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