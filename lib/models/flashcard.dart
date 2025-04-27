class FlashCard {
  final int? id;
  final int deckId;
  final String question;
  final String answer;
  final DateTime createdAt;

  FlashCard({
    this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  FlashCard copy({
    int? id,
    int? deckId,
    String? question,
    String? answer,
    DateTime? createdAt,
  }) =>
      FlashCard(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'deck_id': deckId,
      'question': question,
      'answer': answer,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static FlashCard fromMap(Map<String, dynamic> map) {
    return FlashCard(
      id: map['id'] as int?,
      deckId: map['deck_id'] as int,
      question: map['question'] as String,
      answer: map['answer'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}