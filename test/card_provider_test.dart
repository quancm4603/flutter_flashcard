import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard_app/providers/card_provider.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:flashcard_app/database/database_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([DatabaseHelper])
import 'card_provider_test.mocks.dart';

void main() {
  late CardProvider cardProvider;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    cardProvider = CardProvider();
    cardProvider.setDatabaseHelper(mockDatabaseHelper); // Inject mock database helper
  });

  group('CardProvider', () {
    test('should fetch cards for a specific deck', () async {
      // Arrange
      final mockCards = [
        FlashCard(
          id: 1,
          deckId: 1,
          question: 'What is 2+2?',
          answer: '4',
          isMastered: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        FlashCard(
          id: 2,
          deckId: 1,
          question: 'What is the capital of France?',
          answer: 'Paris',
          isMastered: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      when(mockDatabaseHelper.getCardsForDeck(1)).thenAnswer((_) async => mockCards);

      // Act
      final cards = await cardProvider.getCardsForDeck(1);

      // Assert
      expect(cards.length, 2);
      expect(cards.first.question, 'What is 2+2?');
    });

    test('should add a new card', () async {
      // Arrange
      final newCard = FlashCard(
        id: 1,
        deckId: 1,
        question: 'What is 2+2?',
        answer: '4',
        isMastered: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      when(mockDatabaseHelper.createCard(any)).thenAnswer((_) async => newCard);

      // Act
      await cardProvider.addCard(1, 'What is 2+2?', '4');

      // Assert
      verify(mockDatabaseHelper.createCard(any)).called(1);
    });

    test('should update an existing card', () async {
      // Arrange
      final updatedCard = FlashCard(
        id: 1,
        deckId: 1,
        question: 'Updated Question',
        answer: 'Updated Answer',
        isMastered: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      when(mockDatabaseHelper.updateCard(updatedCard)).thenAnswer((_) async => 1);

      // Act
      await cardProvider.updateCard(updatedCard);

      // Assert
      verify(mockDatabaseHelper.updateCard(updatedCard)).called(1);
    });

    test('should delete a card', () async {
      // Arrange
      when(mockDatabaseHelper.deleteCard(1)).thenAnswer((_) async => 1);

      // Act
      await cardProvider.deleteCard(1);

      // Assert
      verify(mockDatabaseHelper.deleteCard(1)).called(1);
    });

    test('should delete all cards for a deck', () async {
      // Arrange
      when(mockDatabaseHelper.deleteAllCardsForDeck(1)).thenAnswer((_) async => 1);

      // Act
      await cardProvider.deleteAllCardsForDeck(1);

      // Assert
      verify(mockDatabaseHelper.deleteAllCardsForDeck(1)).called(1);
    });

    test('should toggle card mastery', () async {
      // Arrange
      when(mockDatabaseHelper.toggleCardMastery(1, true)).thenAnswer((_) async => 1);

      // Act
      await cardProvider.toggleCardMastery(1, true);

      // Assert
      verify(mockDatabaseHelper.toggleCardMastery(1, true)).called(1);
    });
  });
}