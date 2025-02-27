import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pokemon_card.dart';

class DeckPreferences {
  static const String _deckKey = 'pokemon_deck';

  Future<void> saveDeck(List<PokemonCard> deck) async {
    final prefs = await SharedPreferences.getInstance();
    
    final List<Map<String, dynamic>> jsonList = deck.map((card) => card.toJson()).toList();
    final String jsonString = jsonEncode(jsonList);
    
    print("💾 Saving to SharedPreferences: $jsonString");
    await prefs.setString(_deckKey, jsonString);
  }

  Future<List<PokemonCard>> loadDeck() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_deckKey);

    if (jsonString == null || jsonString.isEmpty) {
      print("📝 No deck found in SharedPreferences");
      return [];
    }

    try {
      print("📖 Loading from SharedPreferences: $jsonString");
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      return jsonList.map<PokemonCard>((json) {
        print("🃏 Processing card JSON: $json");
        return PokemonCard.fromJson(json as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("❌ Error loading deck: $e");
      return [];
    }
  }

  Future<void> addToDeck(PokemonCard card) async {
    final deck = await loadDeck();
    if (!deck.any((existingCard) => existingCard.id == card.id)) {
      deck.add(card);
      await saveDeck(deck);
      print("✅ Added card to deck: ${card.name}");
    } else {
      print("⚠️ Card already exists in deck: ${card.name}");
    }
  }

  Future<void> removeFromDeck(String id) async {
    final deck = await loadDeck();
    deck.removeWhere((card) => card.id == id);
    await saveDeck(deck);
    print("🗑️ Removed card with ID: $id");
  }
}