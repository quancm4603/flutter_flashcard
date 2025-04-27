import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';

class DeckProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Deck> _decks = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Deck> get decks {
    if (_searchQuery.isEmpty) {
      return _decks;
    }
    return _decks.where((deck) =>
        deck.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }
  
  bool get isLoading => _isLoading;

  Future<void> loadDecks() async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Loading decks from database');
      _decks = await _db.getAllDecks();
      debugPrint('Loaded ${_decks.length} decks');
    } catch (e) {
      debugPrint('Error loading decks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDeck(String title, String? description) async {
    try {
      final deck = Deck(
        title: title,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final newDeck = await _db.createDeck(deck);
      _decks.insert(0, newDeck);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding deck: $e');
      rethrow;
    }
  }

  Future<void> updateDeck(Deck deck) async {
    try {
      await _db.updateDeck(deck);
      final index = _decks.indexWhere((d) => d.id == deck.id);
      if (index != -1) {
        _decks[index] = deck;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating deck: $e');
      rethrow;
    }
  }

  Future<void> deleteDeck(int id) async {
    try {
      await _db.deleteDeck(id);
      _decks.removeWhere((deck) => deck.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting deck: $e');
      rethrow;
    }
  }

  // Card operations
  Future<List<FlashCard>> getCardsForDeck(int deckId) async {
    try {
      return await _db.getCardsForDeck(deckId);
    } catch (e) {
      debugPrint('Error getting cards: $e');
      return [];
    }
  }

  Future<void> addCard(int deckId, String question, String answer) async {
    try {
      final card = FlashCard(
        deckId: deckId,
        question: question,
        answer: answer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _db.createCard(card);
      // Refresh deck counts
      await refreshDeckData(deckId);
    } catch (e) {
      debugPrint('Error adding card: $e');
      rethrow;
    }
  }

  Future<void> toggleCardMastery(int cardId, int deckId, bool isMastered) async {
    try {
      await _db.toggleCardMastery(cardId, isMastered);
      // Refresh deck counts
      await refreshDeckData(deckId);
    } catch (e) {
      debugPrint('Error toggling card mastery: $e');
      rethrow;
    }
  }

  Future<void> refreshDeckData(int deckId) async {
    try {
      final updatedDeck = await _db.getDeck(deckId);
      if (updatedDeck != null) {
        final index = _decks.indexWhere((d) => d.id == deckId);
        if (index != -1) {
          _decks[index] = updatedDeck;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error refreshing deck data: $e');
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}