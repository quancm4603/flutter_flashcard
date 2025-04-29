import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard_app/screens/study_mode_screen.dart';
import 'package:flashcard_app/models/flashcard.dart';
import 'package:provider/provider.dart';
import 'package:flashcard_app/providers/card_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([CardProvider])
import 'study_mode_screen_test.mocks.dart';

void main() {
  group('StudyModeScreen', () {
    late List<FlashCard> mockCards;

    setUp(() {
      mockCards = [
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
    });

    testWidgets('should display the front of the first card by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StudyModeScreen(cards: mockCards),
        ),
      );

      // Verify the front of the first card is displayed
      expect(find.text('What is 2+2?'), findsOneWidget);
      expect(find.text('4'), findsNothing);
    });

    testWidgets('should flip the card when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StudyModeScreen(cards: mockCards),
        ),
      );

      // Tap the card to flip
      await tester.tap(find.byKey(const Key('flashcard_gesture_detector')));
      await tester.pumpAndSettle();

      // Verify the back of the card is displayed
      expect(find.text('4'), findsOneWidget);
      expect(find.text('What is 2+2?'), findsNothing);
    });

    testWidgets('should navigate to the next card when the next button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StudyModeScreen(cards: mockCards),
        ),
      );

      // Tap the next button
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Verify the front of the second card is displayed
      expect(find.text('What is the capital of France?'), findsOneWidget);
      expect(find.text('What is 2+2?'), findsNothing);
    });

    testWidgets('should navigate to the previous card when the previous button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StudyModeScreen(cards: mockCards, initialIndex: 1),
        ),
      );

      // Tap the previous button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify the front of the first card is displayed
      expect(find.text('What is 2+2?'), findsOneWidget);
      expect(find.text('What is the capital of France?'), findsNothing);
    });

    testWidgets('should toggle the mastery status when the star button is pressed', (WidgetTester tester) async {
      final mockCardProvider = MockCardProvider();

      when(mockCardProvider.toggleCardMastery(any, any)).thenAnswer((_) async {});

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CardProvider>.value(value: mockCardProvider),
          ],
          child: MaterialApp(
            home: StudyModeScreen(cards: mockCards),
          ),
        ),
      );

      // Verify the initial mastery status
      expect(find.byIcon(Icons.star_border), findsOneWidget);

      // Tap the star button to toggle mastery
      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pumpAndSettle();

      // Verify the mastery status is updated
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should update the progress bar as the user navigates through cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StudyModeScreen(cards: mockCards),
        ),
      );

      // Verify initial progress
      LinearProgressIndicator progressBar = tester.widget(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 1 / mockCards.length);

      // Navigate to the next card
      await tester.tap(find.byIcon(Icons.arrow_forward));
      await tester.pumpAndSettle();

      // Verify updated progress
      progressBar = tester.widget(find.byType(LinearProgressIndicator));
      expect(progressBar.value, 2 / mockCards.length);
    });
  });
}