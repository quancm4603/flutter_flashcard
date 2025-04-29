import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard_app/providers/deck_provider.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/database/database_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'deck_provider_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late DeckProvider deckProvider;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    deckProvider = DeckProvider();
    deckProvider.setDatabaseHelper(mockDatabaseHelper);
  });

  group('DeckProvider', () {
    test('should load decks from the database', () async {
      // Arrange
      final mockDecks = [
        Deck(id: 1, title: 'Math', description: 'Algebra', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Deck(id: 2, title: 'Science', description: 'Physics', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];
      when(mockDatabaseHelper.getAllDecks()).thenAnswer((_) async => mockDecks);

      // Act
      await deckProvider.loadDecks();

      // Assert
      expect(deckProvider.decks.length, 2);
      expect(deckProvider.decks.first.title, 'Math');
      expect(deckProvider.isLoading, false);
    });

    test('should add a new deck', () async {
      // Arrange
      final newDeck = Deck(id: 1, title: 'History', description: 'World War II', createdAt: DateTime.now(), updatedAt: DateTime.now());
      when(mockDatabaseHelper.createDeck(any)).thenAnswer((_) async => newDeck);

      // Act
      await deckProvider.addDeck(newDeck.title, newDeck.description);

      // Assert
      expect(deckProvider.decks.length, 1);
      expect(deckProvider.decks.first.title, 'History');
    });

    test('should update an existing deck', () async {
      // Arrange
      final existingDeck = Deck(id: 1, title: 'Math', description: 'Algebra', createdAt: DateTime.now(), updatedAt: DateTime.now());
      final updatedDeck = Deck(id: 1, title: 'Math', description: 'Geometry', createdAt: DateTime.now(), updatedAt: DateTime.now());
      deckProvider.decks.add(existingDeck);
      when(mockDatabaseHelper.updateDeck(updatedDeck)).thenAnswer((_) async => 1);

      // Act
      await deckProvider.updateDeck(updatedDeck);

      // Assert
      expect(deckProvider.decks.first.description, 'Geometry');
    });

    test('should delete a deck', () async {
      // Arrange
      final deckToDelete = Deck(id: 1, title: 'Math', description: 'Algebra', createdAt: DateTime.now(), updatedAt: DateTime.now());
      deckProvider.decks.add(deckToDelete);
      when(mockDatabaseHelper.deleteDeck(deckToDelete.id!)).thenAnswer((_) async => 1);

      // Act
      await deckProvider.deleteDeck(deckToDelete.id!);

      // Assert
      expect(deckProvider.decks.isEmpty, true);
    });

    test('should filter decks based on search query', () {
      // Arrange
      final mockDecks = [
        Deck(id: 1, title: 'Math', description: 'Algebra', createdAt: DateTime.now(), updatedAt: DateTime.now()),
        Deck(id: 2, title: 'Science', description: 'Physics', createdAt: DateTime.now(), updatedAt: DateTime.now()),
      ];
      deckProvider.decks.addAll(mockDecks);

      // Act
      deckProvider.setSearchQuery('math');

      // Assert
      expect(deckProvider.decks.length, 1);
      expect(deckProvider.decks.first.title, 'Math');
    });
  });
}