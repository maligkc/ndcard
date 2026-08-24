class CardGroup {
  const CardGroup({
    required this.id,
    required this.userId,
    required this.name,
    this.cardCount = 0,
  });

  final String id;
  final String userId;
  final String name;

  /// Liste ekranlarında gösterim için; repository tarafından hesaplanır.
  final int cardCount;

  CardGroup copyWith({String? name, int? cardCount}) {
    return CardGroup(
      id: id,
      userId: userId,
      name: name ?? this.name,
      cardCount: cardCount ?? this.cardCount,
    );
  }
}
