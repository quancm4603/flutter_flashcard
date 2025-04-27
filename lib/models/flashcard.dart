class FlashCard {
  final int? id;
  final int deckId;
  final String question;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isMastered;

  FlashCard({
    this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
    this.isMastered = false,
  });

  FlashCard copy({
    int? id,
    int? deckId,
    String? question,
    String? answer,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isMastered,
  }) =>
      FlashCard(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isMastered: isMastered ?? this.isMastered,
      );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'deck_id': deckId,
      'question': question,
      'answer': answer,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_mastered': isMastered ? 1 : 0,
    };
  }

  static FlashCard fromMap(Map<String, dynamic> map) {
    return FlashCard(
      id: map['id'] as int?,
      deckId: map['deck_id'] as int,
      question: map['question'] as String,
      answer: map['answer'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      isMastered: (map['is_mastered'] as int) == 1,
    );
  }
}