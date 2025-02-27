import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import '../services/pokemon_api.dart';
import '../models/pokemon_card.dart';
import 'deck_screen.dart';
import 'deck_preferences.dart';
import 'pokemon_detail_screen.dart'; 

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<PokemonCard>> _pokemonCards;
  final TextEditingController _searchController = TextEditingController();
  final DeckPreferences _deckPreferences = DeckPreferences();
  List<PokemonCard> _deck = [];
  Set<String> _deckIds = {};
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pokemonCards = PokemonApiService().searchPokemonCards('');
    _loadDeck();
  }

  Future<void> _loadDeck() async {
    final deck = await _deckPreferences.loadDeck();
    if (mounted) {
      setState(() {
        _deck = deck;
        _deckIds = deck.map((card) => card.id).toSet();
      });
    }
  }

  void _toggleDeck(PokemonCard card) async {
    final wasInDeck = _deckIds.contains(card.id);
    final newDeck = List<PokemonCard>.from(_deck);

    setState(() {
      if (wasInDeck) {
        newDeck.removeWhere((c) => c.id == card.id);
      } else {
        newDeck.add(card);
      }
      _deck = newDeck;
      _deckIds = newDeck.map((c) => c.id).toSet();
    });

    await _deckPreferences.saveDeck(newDeck);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _pokemonCards = PokemonApiService().searchPokemonCards(query);
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        actions: [
          IconButton(
            icon: const Icon(Icons.deck),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeckScreen(deck: _deck),
                ),
              );
              _loadDeck();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Pokémon',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<PokemonCard>>(
              future: _pokemonCards,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Pokémon found'));
                }

                final cards = snapshot.data!;
                return ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    final isInDeck = _deckIds.contains(card.id);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PokemonDetailScreen(card: card),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: card.imageUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image),
                          ),
                          title: Text(card.name),
                          subtitle: Text(card.typesDisplay),
                          trailing: IconButton(
                            icon: Icon(
                              isInDeck ? Icons.star : Icons.star_border,
                              color: isInDeck ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () => _toggleDeck(card),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
