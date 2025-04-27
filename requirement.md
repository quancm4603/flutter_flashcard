Exercise 1: Brainstorming Ideas & Features
Core Features (MVP): Please suggest 5-7 core features that absolutely must be in the first version?
Create Flashcard Decks
Users can create decks (e.g., “French Vocabulary”, “Biology Terms”).
Each deck can be named and optionally described.
Add/Edit Flashcards (Front & Back)
Users can add cards to decks.
Each card has a front (e.g., term/question) and back (e.g., definition/answer).
Edit/delete flashcards if needed.
Study Mode (Flip Cards)
Users can study a deck by flipping through cards.
Tap to flip between front and back.
Cards are shown one at a time in order (or random if shuffled).
Deck Management (View, Rename, Delete)
View all created decks.
Rename or delete decks easily.
Progress Tracking (Basic)
Track number of cards studied in a session.
Optionally mark cards as "Known" or "Need to Review".
Offline Support (Local Storage)
Save all decks and flashcards locally (using SharedPreferences, Hive, or sqflite).
No login or account required in version 1.
Simple UI with Light/Dark Mode
Clean, intuitive interface.
Support for both light and dark themes for comfort while studying.
Advanced / Optional Features: 3-4 additional 'nice-to-have' features to make the app more appealing in the future.
Spaced Repetition System (SRS)
Implement an algorithm (like Leitner system or SM-2) to show cards at optimal intervals.
Improves long-term memory retention.
Users rate how easy a card was (e.g., Easy, Hard, Forgot) to influence review frequency.
Cloud Sync & User Accounts
Allow users to sign in (email, Google, etc.).
Sync decks to the cloud (Firebase Firestore, for example).
Access flashcards across multiple devices.
Import/Export Decks (e.g., CSV or .txt)
Let users upload or download decks.
Makes it easy to share decks with friends or import large sets.
Audio & Image Support on Cards
Users can add an image or audio clip to either side of a flashcard.
Great for language learning, pronunciation, visual learners, etc.
Common Problems When Studying (Especially with Flashcards)
Problem
Proposed Feature to Solve It
1. Forgetting quickly after studying
➤ Spaced Repetition – Shows cards at calculated intervals to improve retention.
2. Too many cards, overwhelmed
➤ Deck organization & tags – Organize by topic, difficulty, or custom tags.
3. No feedback on progress
➤ Basic Analytics – Show “Mastered”, “Learning”, “Struggling” stats per deck.
4. Passive memorization (not really learning)
➤ Quiz/Test Mode – Turn cards into quick quizzes (e.g. multiple choice, typing).
5. Can't study on-the-go or offline
➤ Offline Support – Save all decks locally so users can study anytime.
6. Can't add multimedia for better memory
➤ Image & Audio Support – Add pictures or pronunciation to reinforce memory.
7. Motivation fades over time
➤ Daily Goals & Streaks – Encourage daily practice with streaks or reminders.
8. Can't share with friends or study groups
➤ Deck Sharing – Export or share decks via link or QR code.

Feature Set Based on Problems
So for a simple but effective mobile flashcard app, the best features to solve user pain points would be:
Spaced Repetition (Memory Optimization)
Deck Organization (Less Overwhelm)
Progress Tracking / Card Status
Quiz Mode for Active Recall
Offline Access
Multimedia Cards (Image/Audio)
Daily Study Reminders / Streaks
Deck Sharing for Collaboration
User role base
 "Hey, I’m a regular user who just wants to get stuff done!"
I’m juggling:
work deadlines
personal errands
maybe school or side projects
 And I want a simple app that helps me feel in control, not overwhelmed.
 Features I’d really want in a simple task app:
Quick Add Task
 “I want to open the app and just type and save a task in under 3 seconds.”
Due Dates & Reminders
 “I don’t want to forget stuff. Let me set a due date and get a notification when it’s close.”
Categories or Lists (Work, Personal, etc.)
 “I need to group tasks. Work stuff should be separate from groceries.”
Mark as Done / Swipe to Complete
 “It feels so satisfying to check things off!”
Today View
 “Just show me what’s due today. I don’t want to dig through everything.”
Simple UI – No Clutter
 “Don’t give me a learning curve. Just a clean interface that works.”
Dark Mode
 “Because I check things late at night sometimes.”
 Bonus (Nice-to-Haves I’d love later)
Voice input: "Let me speak tasks while driving or walking."
Recurring tasks: “Water the plants every 3 days? Yes please.”
Sync across devices or cloud backup.
Drag & reorder tasks manually.
Exercise 2: Creating User Stories, Acceptance Criteria
Create Flashcard Decks
User Story 1: Deck Creation & Naming
As a student,
 I want to create a new flashcard deck with a custom name and description,
 so that I can clearly organize my flashcards by subject or topic and know what each deck is about.
 Acceptance Criteria:
Deck must require a name:
A new flashcard deck cannot be created without entering a name.
The "Create" button should be disabled until a valid name is entered.
Optional description field
Users can optionally add a short description to the deck (e.g., up to 200 characters).
If no description is entered, the deck is still created with just the name.
Deck appears in the main list after creation
Once a deck is created, it should immediately appear in the list of available decks.
The name and description should be visible in the deck preview or details.
User Story 2: Deck Management
As a student,
 I want to view, rename, or delete my flashcard decks,
 so that I can keep my study materials updated and remove any decks I no longer need.
 Acceptance Criteria:
View deck details
Students can see a list of all created flashcard decks.
Each deck entry displays its name and optional description.
Tapping/clicking on a deck opens it to view the flashcards inside.
Rename deck
Students can tap/click an "Edit" or "Rename" option next to a deck.
A dialog/modal appears to enter a new name (and optionally update the description).
A deck name cannot be left empty when saving changes.
Once renamed, the deck's name is updated in the main list.
 Delete deck
Students can tap/click a "Delete" button next to a deck.
A confirmation prompt appears (e.g., "Are you sure you want to delete this deck?").
If confirmed, the deck is removed from the list.
Deleted decks and their flashcards are permanently removed from the system.
Add/Edit Flashcards
User Story 1: Add New Flashcards
As a student,
 I want to add flashcards with a front and back side to a specific deck,
 so that I can build personalized study material with questions and answers or terms and definitions.
 Acceptance Criteria:
 Add front and back content
Students must be able to input content for the front and back sides of each flashcard.
The front side should have a field for entering a question, term, or prompt.
The back side should have a field for entering the answer, definition, or explanation.
Add flashcard to deck
A student can add a flashcard to a specific deck.
Once the flashcard is added, it should immediately be visible within the selected deck.
Flashcards are displayed in the deck in the order they were added unless shuffled later.
Validation for empty fields
The front and back fields cannot be left empty.
The "Add Flashcard" button should remain disabled until both fields are filled with valid content.
User Story 2: Edit or Delete Flashcards
As a student,
 I want to edit or delete individual flashcards,
 so that I can correct mistakes, update content, or remove cards I no longer need.
 Acceptance Criteria:
 Edit flashcard content
Students can tap/click an "Edit" button on any flashcard to modify its content.
A dialog/modal should appear where they can update the front or back content of the flashcard.
Flashcards cannot be saved with an empty front or back field after editing.
 Delete flashcards
Students can tap/click a "Delete" button on any flashcard to remove it from the deck.
A confirmation prompt should appear to confirm the deletion of the flashcard.
Once confirmed, the flash card is permanently removed from the deck.
 Changes reflected immediately
Once a flashcard is edited or deleted, the changes should immediately be reflected in the deck view.
Deleted flashcards should no longer appear in the deck, and edited flashcards should show the updated content.
Study Mode (Flip Cards)
User Story 1: Flip Card Interaction
 As a student, I want to flip a flashcard by tapping or swiping so that I can immediately see the answer on the back.
 Acceptance Criteria:
Flip action available
Tapping or horizontal swipe on the card flips it front⇄back.
Both tap and swipe must respond within 100 ms.
Smooth animation
Flip animation completes within 300 ms without any stutter.
Card content (text and images) remains fully legible during and after the flip.
State persistence
If I navigate away and then return, the card retains its last shown face.
Rotating the device does not reset the flipped state.
User Story 2: Shuffle Cards Order
 As a student, I want to shuffle my flashcards before starting a study session so that the review order is randomized.
 Acceptance Criteria:
Shuffle control
A clearly labeled “Shuffle” button is visible on the study screen.
Tapping “Shuffle” randomizes the order of all cards in the deck.
Order variability
The new sequence must differ from the previous session’s order (unless the deck contains only one card).
Every card appears exactly once; no duplicates or omissions.
Session persistence
The shuffled order remains fixed until the session ends or I tap “Shuffle” again.
Flipping, skipping, or navigating cards does not reset the order.
Deck Management (View, Rename, Delete)
User Story 1: View Decks
 As a student, I want to view a list of all my flashcard decks so that I can choose which one to study.
 Acceptance Criteria:
Deck list clarity
Each deck entry displays: deck name, number of cards, and last‑updated timestamp.
Decks are sorted by last‑updated date in descending order by default.
Loading feedback
If loading takes longer than 1 second, a spinner or skeleton loader appears.
No blank screen is ever shown.
Navigation flow
Tapping a deck opens its Study Mode immediately.
A back button returns me to the deck list without refreshing.
User Story 2: Rename Decks
 As a student, I want to rename a deck so that its title accurately reflects my current study topic.
 Acceptance Criteria:
Edit control
An edit (pencil) icon appears next to each deck in the list.
Tapping the icon transforms the deck title into an inline text input.
Input validation
The new title is required and must be between 1 and 30 characters.
Invalid input displays an inline error and disables the save action.
Real‑time update
Upon saving, the updated title appears instantly in the deck list without page reload.
A toast notification confirms “Deck renamed successfully.”
Progress Tracking (Basic)
User Story 1: Count the number of cards learned in the session
 As a learner, I want the app to count how many cards I’ve studied in a session, so I can track my progress and see how much I’ve covered.
 Acceptance Criteria:
When starting study mode, the studied card counter starts at 0.
Each time a card is flipped (either front or back), it counts as 1 studied card.
At the end of the session, the total number of studied cards is displayed.
User Story 2: Mark the tag “Known” or “Needs Review”
 As a learner, I want to mark each card as “Known” or “Need to Review” so I can focus on the weaker cards.
 Acceptance Criteria:
During a study session, the user can mark each card as either “Known” or “Need to Review”.
The status of each card is saved permanently within its deck.
In future sessions, users can choose to study only the cards marked “Need to Review”.
User Story 3: Progress statistics in card deck
 As a learner, I want to see how many cards I’ve mastered or still need to study in a deck so I can evaluate my understanding.
 Acceptance Criteria:
On the deck info screen, display:
Total number of cards
Number of cards marked as “Known”
Number of cards marked as “Need to Review”
If all cards are marked “Known”, display the status: “Deck Completed”.
Offline Support (Local Storage)
User Story 4: Study without the Internet
 As a learner, I want all decks and flashcard data to be stored directly on my device, so I can study anytime without needing an internet connection.
 Acceptance Criteria:
Users can access all core features (create, edit, study cards) without an internet connection.
Data is stored locally using Hive, sqlite, or SharedPreferences.
Data remains intact after restarting the app.
User Story 5: Use the app without logging in
 As a user who doesn’t want to log in, I want to use the app without needing an account so I can start learning immediately without sign-up interruptions.
 Acceptance Criteria:
The app does not require login in the first version.
On first launch, users are taken directly to the home screen without needing to create an account.
User Story 6: Sustainable learning data storage
 As a user, I want my study data to be stored safely and persistently, so I don’t lose progress or content when reopening the app.
 Acceptance Criteria:
Each deck and its cards are saved with their current status (e.g., known/review).
Data is not lost after the app is closed or the device is restarted.
If a user deletes a deck, all associated data is also deleted from local storage.
Simple UI with Light/Dark Mode
As a User of the flashcards app,
I want the option to switch between light and dark mode in the app,
So that I can study comfortably in different lighting conditions, such as during the day or at night.
 Acceptance Criteria:
Light/Dark Mode Toggle
Given the app is open,
When the user navigates to the settings menu,
Then they should see an option to toggle between light and dark mode.
Persistent Theme Preference
Given the user selects a theme (light or dark),
When the app is closed and reopened,
Then the previously selected theme should be applied automatically.
Default Theme
Given no theme has been selected by the user,
When the app is opened for the first time,
Then the app should default to the device’s system theme (if available) or the light mode.
III. Drafting Basic Specs
For every User Story below, run through these prompts:
Data Fields


List the Dart model fields you’ll need and their types.


Workflow Steps


Describe the user’s UI interactions and the sequence of method calls.


Local Storage Schema


Define tables (for SQLite) or keys (for SharedPreferences) and their columns/values.


UI Components & State


Identify Flutter widgets and state variables (e.g. using ChangeNotifier or Riverpod).


Validation & Error Handling


Specify form rules and how to surface messages in the UI.


Non‑Functional Requirements


Note performance targets (e.g. load ≤200 ms for a deck) and usability considerations.


Testing


Outline unit tests and widget tests needed to cover this feature.
User Story A: Deck Creation & Naming
As a student, I want to create a new flashcard deck with a custom name and description…
Data Fields

 dart
class Deck {
  final int id;               // auto‑increment PK
  String title;               // non‑null
  String? description;        // nullable
  DateTime createdAt;
  DateTime updatedAt;
}
Workflow Steps


Tap “+ Deck” FAB


Show DeckFormScreen with TextFormFields


Validate title non‑empty


On “Save”, call DeckRepository.create(deck)


Insert into SQLite → return new id


Pop back to deck list and refresh


Local Storage Schema
CREATE TABLE decks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL
);
UI Components & State


DeckListScreen: listens to DeckListNotifier (holds List<Deck>)


DeckFormScreen: holds local FormState, title & description controllers


Validation & Error Handling


Title: required, max 50 chars → show inline error under field


DB errors: show a SnackBar with “Failed to save deck.”


Non‑Functional Requirements


Create action completes in <200 ms on test device


Disable “Save” button until form valid


Testing


Unit: DeckRepository.create returns correct id


Widget: DeckFormScreen shows error when title empty, enables Save when valid



User Story B: View/Rename/Delete Decks
As a student, I want to view, rename, or delete my flashcard decks…
Data Fields

 dart
// reuse Deck model
Workflow Steps


DeckListScreen loads all decks via DeckRepository.getAll()


Render each deck with title, count, updatedAt


Tap “Edit” icon → open inline dialog or push DeckFormScreen


On “Rename”, call DeckRepository.update(deck)


On “Delete”, show AlertDialog; if confirmed → DeckRepository.delete(id)
Local Storage Schema

 sql
-- same decks table
UI Components & State


Inline rename: use showDialog with TextFormField


DeckListNotifier updates list on rename/delete


Validation & Error Handling


Rename: non‑empty, max 50 chars


Delete failure: SnackBar “Unable to delete deck.”


Non‑Functional Requirements


List loads in <300 ms even with 100 decks


Swipe‑to‑delete gesture optional for faster action


Testing


Widget test for “swipe to delete”


Unit test for DeckRepository.delete removes correct row



User Story C: Add/Edit/Delete Flashcards
As a student, I want to add flashcards with front/back… edit or delete them…
Data Fields

 dart
class Flashcard {
  final int id;
  final int deckId;        // FK to decks.id
  String frontText;
  String backText;
  DateTime createdAt;
}
Workflow Steps


Add: Tap “+ Card” → CardFormScreen → validate → FlashcardRepository.insert() → refresh list


Edit: Tap card → same form pre‑filled → update() → refresh


Delete: Long‑press or swipe → confirm → delete() → refresh


Local Storage Schema

 sql
CREATE TABLE flashcards (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  deckId INTEGER NOT NULL,
  frontText TEXT NOT NULL,
  backText TEXT NOT NULL,
  createdAt INTEGER NOT NULL,
  FOREIGN KEY(deckId) REFERENCES decks(id) ON DELETE CASCADE
);
UI Components & State


FlashcardListScreen: listens to FlashcardNotifier(deckId)


CardFormScreen: two TextFormFields + Save/Delete buttons


Validation & Error Handling


Both fields required, non‑empty → disable Save until valid


Show inline errors + SnackBar on DB failure


Non‑Functional Requirements


Insert/update/delete complete <150 ms


Persisted changes must be immediately visible


Testing


Unit: CRUD operations in FlashcardRepository


Widget: CardFormScreen validation behavior



User Story D: Study Mode (Flip & Shuffle)
As a student, I want to flip flashcards and optionally shuffle them…
Data Fields

 dart
// reuse Flashcard model
Workflow Steps


Open StudyScreen(deckId)


Load list via FlashcardRepository.getByDeck(deckId)


If “Shuffle” toggled → cards.shuffle()


Display PageView or Swiper widget


On tap/swipe → animate flip (use AnimatedSwitcher)


Track current index in state


Local Storage Schema


No changes; study order in-memory only


UI Components & State


StudyScreenState holds List<Flashcard> cards, int currentIndex, bool isFlipped, bool isShuffled


Validation & Error Handling


If deck empty → show placeholder “No cards yet.”


Disable Shuffle if <2 cards


Non‑Functional Requirements


Flip animation ≤300 ms, 60 fps


Load deck in <200 ms


Testing


Widget test: tap flips card; shuffle changes order



User Story E: Progress Tracking
As a learner, I want to count studied cards and mark Known/Review…
Data Fields

 dart
class FlashcardStatus {
  final int flashcardId; 
  bool isKnown;        
}
Workflow Steps


In StudyScreen, add “Known” / “Review” buttons


On tap → update FlashcardStatusRepository.upsert()


Increment session counter


Local Storage Schema

 sql
CREATE TABLE flashcard_status (
  flashcardId INTEGER PRIMARY KEY,
  isKnown INTEGER NOT NULL,
  FOREIGN KEY(flashcardId) REFERENCES flashcards(id) ON DELETE CASCADE
);
UI Components & State


StudyScreenState adds int studiedCount and uses StatusNotifier


Validation & Error Handling


Disable status buttons until card flipped at least once


Show SnackBar on save failure


Non‑Functional Requirements


Status save <100 ms


Session count updates instantly


Testing


Unit: status repo upsert and fetch


Widget: buttons enable/disable logic



User Story F: Light/Dark Mode Toggle
As a user, I want to switch between light and dark themes…
Data Fields

 dart
// SharedPreferences key:
const themeKey = 'app_theme'; // 'light' | 'dark' | 'system'
Workflow Steps


In SettingsScreen, toggle theme option


On change → save to SharedPreferences


Notify ThemeNotifier → rebuild MaterialApp with new ThemeMode


Local Storage Schema


SharedPreferences: app_theme → string


UI Components & State


SettingsScreen with SwitchListTile


ThemeNotifier provides ThemeMode to MaterialApp


Validation & Error Handling


N/A (simple toggle)


Non‑Functional Requirements


Theme change reflected instantly with no flicker


Testing


Widget test: toggling switch updates theme in UI


Unit: ThemeNotifier persists and restores correct mode

IV. Screen Design:
Create Flashcard Decks

Deck Management (View, Rename, Delete)

Flashcards Management (Front & Back)
Users can list cards in a deck

Users can add cards to decks.

Each card has a front (e.g., term/question) and back (e.g., definition/answer).
Edit/delete flashcards if needed.
Study Mode (Flip Cards)

Users can study a deck by flipping through cards.
Tap to flip between front and back.
Cards are shown one at a time in order (or random if shuffled).
Progress Tracking (Basic)

Track number of cards studied in a session.
Optionally mark cards as "Known" or "Need to Review".
Offline Support (Local Storage)

Save all decks and flashcards locally (using SharedPreferences, Hive, or sqlite).
No login or account required in version 1.
Simple UI with Light/Dark Mode

Clean, intuitive interface.
Support for both light and dark themes for comfort while studying.
