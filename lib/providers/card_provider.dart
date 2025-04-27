import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/flashcard.dart';

class CardProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

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
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding card: $e');
      rethrow;
    }
  }

  Future<void> deleteCard(int cardId) async {
    try {
      await _db.deleteCard(cardId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting card: $e');
      rethrow;
    }
  }

  Future<void> updateCard(FlashCard updatedCard) async {
    try {
      await _db.updateCard(updatedCard);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating card: $e');
      rethrow;
    }
  }

  Future<void> deleteAllCardsForDeck(int deckId) async {
    try {
      await _db.deleteAllCardsForDeck(deckId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting all cards for deck: $e');
      rethrow;
    }
  }

  Future<void> toggleCardMastery(int cardId, bool isMastered) async {
    try {
      await _db.toggleCardMastery(cardId, isMastered);
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling card mastery: $e');
      rethrow;
    }
  }
}