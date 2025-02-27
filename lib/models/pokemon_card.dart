class PokemonCard {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final String rarity;
  final String set;

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.rarity,
    required this.set,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
   
    return PokemonCard(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] != null 
          ? json['imageUrl'] as String  
          : json['images']?['small'] as String? ?? '', 
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      rarity: json['rarity'] as String? ?? 'Unknown',
      set: json['set'] is String 
          ? json['set'] as String  
          : json['set']?['name'] as String? ?? 'Unknown', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'types': types,
      'rarity': rarity,
      'set': set,
    };
  }

  String get typesDisplay => types.isNotEmpty ? types.join(', ') : 'No types';
  String get rarityDisplay => rarity.isNotEmpty ? rarity : 'Unknown';
  String get setDisplay => set.isNotEmpty ? set.toUpperCase() : 'Unknown';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PokemonCard && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PokemonCard{id: $id, name: $name, types: $types}';
  }
}