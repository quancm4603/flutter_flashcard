import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:flashcard_app/screens/deck_cards_screen.dart';
import 'package:flashcard_app/providers/card_provider.dart';
import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/models/flashcard.dart';

import 'package:mockito/annotations.dart';
import 'deck_cards_screen_test.mocks.dart';

@GenerateMocks([CardProvider])
void main() {
  late MockCardProvider mockCardProvider;
  late Deck testDeck;

  setUp(() {
    mockCardProvider = CustomMockCardProvider();
    testDeck = Deck(
      id: 1,
      title: 'Test Deck',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Mock the provider's behavior
    when(mockCardProvider.getCardsForDeck(any)).thenAnswer((_) async => []);
  });

  Widget createTestWidget() {
    return ChangeNotifierProvider<CardProvider>.value(
      value: mockCardProvider,
      child: MaterialApp(
        home: DeckCardsScreen(deck: testDeck),
      ),
    );
  }

  group('DeckCardsScreen Tests', () {
    testWidgets('displays app bar with deck title', (tester) async {
      print('Deck title: ${testDeck.title}'); // Debugging log

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify the app bar title
      expect(find.text('Test Deck'), findsOneWidget);
    });

    testWidgets('displays loading indicator while fetching cards',
        (tester) async {
      when(mockCardProvider.getCardsForDeck(any)).thenAnswer(
        (_) async => Future.delayed(const Duration(seconds: 1), () => []),
      );

      await tester.pumpWidget(createTestWidget());
      // first frame — should show spinner
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // advance fake time to complete the delayed Future and settle any timers
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

    testWidgets('displays message when no cards are available', (tester) async {
      when(mockCardProvider.getCardsForDeck(any)).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('No cards yet. Add your first card!'), findsOneWidget);
    });

    testWidgets('displays list of cards', (tester) async {
      final testCards = [
        FlashCard(
          id: 1,
          question: 'Question 1',
          answer: 'Answer 1',
          isMastered: false,
          deckId: testDeck.id!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        FlashCard(
          id: 2,
          question: 'Question 2',
          answer: 'Answer 2',
          isMastered: true,
          deckId: testDeck.id!,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      when(mockCardProvider.getCardsForDeck(any))
          .thenAnswer((_) async => testCards);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Question 1'), findsOneWidget);
      expect(find.text('Question 2'), findsOneWidget);
    });

    testWidgets('navigates to CreateCardScreen when FAB is tapped',
        (tester) async {
      when(mockCardProvider.getCardsForDeck(any)).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(DeckCardsScreen), findsNothing);
    });

    testWidgets('shows delete confirmation dialog and deletes card',
        (tester) async {
      final testCard = FlashCard(
        id: 1,
        question: 'Question 1',
        answer: 'Answer 1',
        isMastered: false,
        deckId: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      when(mockCardProvider.getCardsForDeck(any))
          .thenAnswer((_) async => [testCard]);
      when(mockCardProvider.deleteCard(any)).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete Card'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(mockCardProvider.deleteCard(testCard.id!)).called(1);
    });

    testWidgets('toggles card mastery status', (tester) async {
      final testCard = FlashCard(
        id: 1,
        question: 'Question 1',
        answer: 'Answer 1',
        isMastered: false,
        deckId: testDeck.id!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // 1) initial fetch returns unmastered card
      when(mockCardProvider.getCardsForDeck(any))
          .thenAnswer((_) async => [testCard]);

      // 2) when toggle is called, stub getCardsForDeck to now return the mastered card
      when(mockCardProvider.toggleCardMastery(testCard.id!, true))
          .thenAnswer((_) async {
        final updatedCard = testCard.copy(isMastered: true);
        when(mockCardProvider.getCardsForDeck(any))
            .thenAnswer((_) async => [updatedCard]);
        mockCardProvider.notifyListeners();
      });

      // Pump & settle
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // verify initial (unmastered) icon
      expect(find.byIcon(Icons.star_border), findsOneWidget);

      // tap to toggle
      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pumpAndSettle();

      // verify the toggle was called
      verify(mockCardProvider.toggleCardMastery(testCard.id!, true)).called(1);

      // now the mocked provider has re‑fetched a mastered card and notified listeners,
      // so the UI should rebuild with a filled star
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}

class CustomMockCardProvider extends MockCardProvider {
  final _listeners = <VoidCallback>[];

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  Future<void> toggleCardMastery(int? cardId, bool? isMastered) =>
      super.noSuchMethod(
        Invocation.method(#toggleCardMastery, [cardId, isMastered]),
        returnValue: Future.value(),
      ) as Future<void>;
}
