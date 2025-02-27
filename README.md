# Final Flutter Project

A Flutter app that displays a list of Pokémon TCG cards. Users can add cards to a deck, view card details, and check a calendar with past and upcoming TCG tournaments.

## Features
- **Pokémon Card List**: Browse Pokémon TCG cards.
- **Deck Builder**: Add and remove cards from your deck.
- **Card Details**: View detailed information about each card.
- **TCG Tournament Calendar**: See past and upcoming tournament dates.

## API Used
### Pokémon TCG API.

- **Base URL**: `https://api.pokemontcg.io/v2/`
- **No authentication required**
- **Endpoints**:
  - `GET /cards`: Retrieve all Pokémon cards.
  - `GET /cards/:id`: Get details of a specific card.
  - `GET /sets`: List all card sets.
  - `GET /types`: Retrieve all Pokémon types.

For more details, visit the [Pokémon TCG API Documentation](https://api.pokemontcg.io).
