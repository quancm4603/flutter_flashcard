V. Unit Test Concept for the Flashcard App
1. Providers
Providers are the backbone of state management in this app. Unit tests should focus on their logic and ensure they behave as expected.

ThemeProvider
Test toggling between light, dark, and system themes.
Verify that the correct ThemeMode is returned after toggling.
Ensure the theme state persists correctly (e.g., using SharedPreferences).
DeckProvider
Test CRUD operations for decks:
Create a new deck and verify it is added to the list.
Update a deck's title or description and ensure the changes are reflected.
Delete a deck and verify it is removed from the list.
Test error handling (e.g., database failures).
Verify that the deck list refreshes correctly after operations.
CardProvider
Test CRUD operations for flashcards:
Add a new card to a deck and verify it is added.
Update a card's front or back text and ensure the changes are reflected.
Delete a card and verify it is removed.
Test toggling the mastery status of a card.
Verify that cards are fetched correctly for a specific deck.
2. Repositories
Repositories handle database interactions. Unit tests should ensure that the database operations work as expected.

Deck Repository
Test SQL queries for inserting, updating, deleting, and fetching decks.
Verify that foreign key constraints (e.g., cascading deletes) work correctly.
Flashcard Repository
Test SQL queries for inserting, updating, deleting, and fetching flashcards.
Verify that flashcards are correctly associated with their respective decks.
3. Widgets
Widget tests ensure that the UI behaves as expected under different scenarios.

HomeScreen
Verify that the list of decks is displayed correctly.
Test navigation to DeckCardsScreen when a deck is tapped.
Test the "Create Deck" flow:
Tap the FAB to open the CreateDeckScreen.
Enter valid/invalid input and verify the "Save" button behavior.
Test the "Edit Deck" flow:
Tap the edit icon to open the EditDeckScreen.
Modify the deck and verify the changes are reflected on the HomeScreen.
DeckCardsScreen
Verify that the list of cards is displayed correctly for a deck.
Test the "Create Card" flow:
Tap the FAB to open the CreateCardScreen.
Enter valid/invalid input and verify the "Save" button behavior.
Test the "Edit Card" flow:
Tap the edit icon to open the EditCardScreen.
Modify the card and verify the changes are reflected on the DeckCardsScreen.
Test the "Delete Card" flow:
Tap the delete icon and confirm the deletion.
Verify that the card is removed from the list.
StudyModeScreen
Test flipping the card:
Tap the card and verify the front/back text changes.
Ensure the flip animation works correctly.
Test navigation between cards:
Tap the next/previous buttons and verify the correct card is displayed.
Test the shuffle functionality:
Enable shuffle and verify the card order changes.
Test the star button:
Tap the star button and verify the mastery status toggles.
4. Navigation
Navigation tests ensure that the app transitions between screens correctly.

Test navigation from HomeScreen to DeckCardsScreen and back.
Test navigation from DeckCardsScreen to CreateCardScreen, EditCardScreen, and StudyModeScreen.
Verify that the state (e.g., deck list, card list) is refreshed when navigating back.
5. Validation and Error Handling
Validation tests ensure that user input is handled correctly, and error handling tests verify that the app behaves gracefully under failure scenarios.

Validation
Test required fields (e.g., deck name, card front/back text).
Verify that invalid input shows appropriate error messages.

Error Handling
Simulate database failures and verify that error messages (e.g., SnackBars) are displayed.
Test edge cases (e.g., deleting a deck with no cards, flipping an empty deck).
6. Performance
Performance tests ensure that the app meets its non-functional requirements.

Verify that decks and cards load within the specified time limits (e.g., ≤200 ms for a deck).
Ensure that animations (e.g., card flip) run smoothly at 60 fps.
7. Testing Tools
Unit Tests
Use the flutter_test package for unit testing providers and repositories.
Widget Tests
Use the flutter_test package for widget tests.
Use WidgetTester to simulate user interactions (e.g., taps, text input).
Integration Tests
Use the integration_test package to test end-to-end flows (e.g., creating a deck, adding cards, studying the deck).

