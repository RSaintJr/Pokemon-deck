import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_card.dart';

class PokemonApiService {
  static const String _baseUrl = 'https://api.pokemontcg.io/v2/cards';

  Future<List<PokemonCard>> searchPokemonCards(String query) async {
    try {
      final String url = query.isNotEmpty
          ? '$_baseUrl?q=name:$query'
          : _baseUrl;

      final response = await http.get(Uri.parse(url), headers: {
        'X-Api-Key': '3c0deec3-7476-45b5-b898-439e3dda69b0' 
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cardsJson = data['data'];
        return cardsJson.map((json) => PokemonCard.fromJson(json)).toList();
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      return [];
    }
  }
}
