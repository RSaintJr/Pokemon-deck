import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class DeckScreen extends StatelessWidget {
  final List<PokemonCard> deck;

  const DeckScreen({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Deck')),
      body: deck.isEmpty
          ? const Center(
              child: Text(
                'Seu deck está vazio!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: deck.length,
              itemBuilder: (context, index) {
                final card = deck[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetailScreen(card: card),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CachedNetworkImage(
                        imageUrl: card.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                      title: Text(card.name),
                      subtitle: Text(card.rarityDisplay),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
