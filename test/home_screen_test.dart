import 'package:flashcard_app/models/deck.dart';
import 'package:flashcard_app/providers/card_provider.dart';
import 'package:flashcard_app/providers/deck_provider.dart';
import 'package:flashcard_app/providers/theme_provider.dart';
import 'package:flashcard_app/screens/home_screen.dart';
import 'package:flashcard_app/screens/create_deck_screen.dart';
import 'package:flashcard_app/screens/deck_cards_screen.dart';
import 'package:flashcard_app/screens/edit_deck_screen.dart';
import 'package:flashcard_app/components/settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';

// Generate mock classes for our providers
@GenerateNiceMocks([
  MockSpec<DeckProvider>(),
  MockSpec<CardProvider>(),
  MockSpec<ThemeProvider>()
])
import 'home_screen_test.mocks.dart';

void main() {
  late MockDeckProvider mockDeckProvider;
  late MockCardProvider mockCardProvider;
  late MockThemeProvider mockThemeProvider;

  setUp(() {
    mockDeckProvider = MockDeckProvider();
    mockCardProvider = MockCardProvider();
    mockThemeProvider = MockThemeProvider();
  });

  Widget createHomeScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DeckProvider>.value(value: mockDeckProvider),
        ChangeNotifierProvider<CardProvider>.value(value: mockCardProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: mockThemeProvider),
      ],
      child: MaterialApp(
        home: const HomeScreen(),
      ),
    );
  }

  testWidgets('HomeScreen shows loading indicator when isLoading is true', 
    (WidgetTester tester) async {
    // Setup
    when(mockDeckProvider.isLoading).thenReturn(true);
    when(mockDeckProvider.decks).thenReturn([]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Verify
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('No decks yet. Create your first deck!'), findsNothing);
  });

  testWidgets('HomeScreen shows empty state message when no decks', 
    (WidgetTester tester) async {
    // Setup
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Verify
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No decks yet. Create your first deck!'), findsOneWidget);
  });

  testWidgets('HomeScreen shows list of decks when decks are available', 
    (WidgetTester tester) async {
    // Setup
    final testDecks = [
      Deck(id: 1, title: 'Test Deck 1', description: 'Description 1', cardCount: 10, masteredCount: 5, createdAt: DateTime(2023), updatedAt: DateTime(2023)),
      Deck(id: 2, title: 'Test Deck 2', description: 'Description 2', cardCount: 8, masteredCount: 2, createdAt: DateTime(2023), updatedAt: DateTime(2023)),
    ];
    
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn(testDecks);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Verify
    expect(find.text('Test Deck 1'), findsOneWidget);
    expect(find.text('Test Deck 2'), findsOneWidget);
    expect(find.text('5/10 cards mastered'), findsOneWidget);
    expect(find.text('2/8 cards mastered'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
  });

  testWidgets('Tapping FAB navigates to CreateDeckScreen', 
    (WidgetTester tester) async {
    // Setup
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Act - tap the FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify
    expect(find.byType(CreateDeckScreen), findsOneWidget);
  });

  testWidgets('Tapping a deck navigates to DeckCardsScreen', 
    (WidgetTester tester) async {
    // Setup
    final testDeck = Deck(
      id: 1, 
      title: 'Test Deck', 
      description: 'Description', 
      cardCount: 10, 
      masteredCount: 5,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023)
    );
    
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([testDeck]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Act - tap the deck card
    await tester.tap(find.text('Test Deck'));
    await tester.pumpAndSettle();

    // Verify
    expect(find.byType(DeckCardsScreen), findsOneWidget);
  });

  testWidgets('Tapping edit icon navigates to EditDeckScreen', 
    (WidgetTester tester) async {
    // Setup
    final testDeck = Deck(
      id: 1, 
      title: 'Test Deck', 
      description: 'Description', 
      cardCount: 10, 
      masteredCount: 5,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023)
    );
    
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([testDeck]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Find and tap the edit button
    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    // Verify
    expect(find.byType(EditDeckScreen), findsOneWidget);
  });

  testWidgets('Tapping delete icon shows confirmation dialog', 
    (WidgetTester tester) async {
    // Setup
    final testDeck = Deck(
      id: 1, 
      title: 'Test Deck', 
      description: 'Description', 
      cardCount: 10, 
      masteredCount: 5,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023)
    );
    
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([testDeck]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Find and tap the delete button
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Verify dialog appears
    expect(find.text('Delete Deck'), findsOneWidget);
    expect(find.text('Are you sure you want to delete the deck "Test Deck"? This will also delete all associated cards.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('Confirming deck deletion calls deleteDeck and deleteAllCardsForDeck', 
    (WidgetTester tester) async {
    // Setup
    final testDeck = Deck(
      id: 1, 
      title: 'Test Deck', 
      description: 'Description', 
      cardCount: 10, 
      masteredCount: 5,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023)
    );
    
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([testDeck]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Find and tap the delete button
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Tap the Delete button in the dialog
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // Verify the appropriate provider methods were called
    verify(mockDeckProvider.deleteDeck(1)).called(1);
    verify(mockCardProvider.deleteAllCardsForDeck(1)).called(1);
  });

  testWidgets('Canceling deck deletion does not call deleteDeck', 
    (WidgetTester tester) async {
    // Setup
    final testDeck = Deck(
      id: 1, 
      title: 'Test Deck', 
      description: 'Description', 
      cardCount: 10, 
      masteredCount: 5,
      createdAt: DateTime(2023),
      updatedAt: DateTime(2023)
    );
    
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([testDeck]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Find and tap the delete button
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();

    // Tap the Cancel button in the dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Verify the delete methods were not called
    verifyNever(mockDeckProvider.deleteDeck(any));
    verifyNever(mockCardProvider.deleteAllCardsForDeck(any));
  });

  testWidgets('Entering search text calls setSearchQuery on DeckProvider', 
    (WidgetTester tester) async {
    // Setup
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Find the search field and enter text
    await tester.enterText(find.byType(TextField), 'search term');
    
    // Verify
    verify(mockDeckProvider.setSearchQuery('search term')).called(1);
  });

  testWidgets('Tapping settings icon opens SettingsDialog', 
    (WidgetTester tester) async {
    // Setup
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([]);

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Tap the settings icon
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    // Verify
    expect(find.byType(SettingsDialog), findsOneWidget);
  });
  
  testWidgets('Pull-to-refresh calls loadDecks on DeckProvider', 
    (WidgetTester tester) async {
    // Setup
    when(mockDeckProvider.isLoading).thenReturn(false);
    when(mockDeckProvider.decks).thenReturn([
      Deck(id: 1, title: 'Test Deck', description: 'Description', cardCount: 10, masteredCount: 5, createdAt: DateTime(2023), updatedAt: DateTime(2023))
    ]);
    when(mockDeckProvider.loadDecks()).thenAnswer((_) => Future.value());

    // Build the widget
    await tester.pumpWidget(createHomeScreen());

    // Perform pull-to-refresh gesture
    await tester.drag(find.text('Test Deck'), const Offset(0, 300));
    await tester.pumpAndSettle();

    // Verify
    verify(mockDeckProvider.loadDecks()).called(greaterThan(0));
  });
}
