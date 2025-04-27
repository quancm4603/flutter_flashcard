import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/deck.dart';

class DeckProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Deck> _decks = [];
  bool _isLoading = false;

  List<Deck> get decks => _decks;
  bool get isLoading => _isLoading;

  Future<void> loadDecks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _decks = await _db.getAllDecks();
    } catch (e) {
      debugPrint('Error loading decks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDeck(String title, String? description) async {
    final deck = Deck(
      title: title,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
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
}
