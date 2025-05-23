class Deck {
  final int? id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int cardCount;
  final int masteredCount;

  // Calculate mastery percentage
  double get masteryPercentage => cardCount > 0 ? (masteredCount / cardCount) * 100 : 0;
  
  // Format mastery percentage for display
  String get masteryPercentageFormatted => "${masteryPercentage.round()}%";

  Deck({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.cardCount = 0,
    this.masteredCount = 0,
  });

  Deck copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? cardCount,
    int? masteredCount,
  }) =>
      Deck(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        cardCount: cardCount ?? this.cardCount,
        masteredCount: masteredCount ?? this.masteredCount,
      );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static Deck fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}