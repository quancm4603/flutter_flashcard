import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('flashcard_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      debugPrint('Database path: $path');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onOpen: (db) {
          debugPrint('Database opened successfully');
        },
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      debugPrint('Creating database tables');
      
      // Create decks table
      await db.execute('''
        CREATE TABLE decks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          description TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      
      // Create cards table
      await db.execute('''
        CREATE TABLE cards (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          deck_id INTEGER NOT NULL,
          question TEXT NOT NULL,
          answer TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL,
          is_mastered INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY (deck_id) REFERENCES decks (id) ON DELETE CASCADE
        )
      ''');
      
      debugPrint('Database tables created successfully');
    } catch (e) {
      debugPrint('Error creating database tables: $e');
      rethrow;
    }
  }

  // DECK OPERATIONS
  Future<Deck> createDeck(Deck deck) async {
    try {
      final db = await database;
      final id = await db.insert('decks', deck.toMap());
      debugPrint('Created deck with ID: $id');
      return deck.copy(id: id);
    } catch (e) {
      debugPrint('Error creating deck: $e');
      rethrow;
    }
  }

  Future<List<Deck>> getAllDecks() async {
    try {
      final db = await database;
      
      // Get all decks ordered by creation date (newest first)
      final decksResult = await db.query('decks', orderBy: 'created_at DESC');
      
      // Create list to hold decks with card counts
      List<Deck> decks = [];
      
      // For each deck, count total cards and mastered cards
      for (var deckMap in decksResult) {
        final deckId = deckMap['id'] as int;
        
        // Count total cards
        final countResult = await db.rawQuery(
          'SELECT COUNT(*) as total FROM cards WHERE deck_id = ?', 
          [deckId]
        );
        final cardCount = Sqflite.firstIntValue(countResult) ?? 0;
        
        // Count mastered cards
        final masteredResult = await db.rawQuery(
          'SELECT COUNT(*) as mastered FROM cards WHERE deck_id = ? AND is_mastered = 1', 
          [deckId]
        );
        final masteredCount = Sqflite.firstIntValue(masteredResult) ?? 0;
        
        // Create deck with counts
        final deck = Deck.fromMap(deckMap);
        decks.add(deck.copy(
          cardCount: cardCount,
          masteredCount: masteredCount
        ));
      }
      
      return decks;
    } catch (e) {
      debugPrint('Error getting all decks: $e');
      return [];
    }
  }

  Future<Deck?> getDeck(int id) async {
    try {
      final db = await database;
      final maps = await db.query(
        'decks',
        columns: ['id', 'title', 'description', 'created_at', 'updated_at'],
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        // Count total cards
        final countResult = await db.rawQuery(
          'SELECT COUNT(*) as total FROM cards WHERE deck_id = ?', 
          [id]
        );
        final cardCount = Sqflite.firstIntValue(countResult) ?? 0;
        
        // Count mastered cards
        final masteredResult = await db.rawQuery(
          'SELECT COUNT(*) as mastered FROM cards WHERE deck_id = ? AND is_mastered = 1', 
          [id]
        );
        final masteredCount = Sqflite.firstIntValue(masteredResult) ?? 0;
        
        final deck = Deck.fromMap(maps.first);
        return deck.copy(
          cardCount: cardCount,
          masteredCount: masteredCount
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error getting deck: $e');
      return null;
    }
  }

  Future<int> updateDeck(Deck deck) async {
    try {
      final db = await database;
      return db.update(
        'decks',
        deck.toMap(),
        where: 'id = ?',
        whereArgs: [deck.id],
      );
    } catch (e) {
      debugPrint('Error updating deck: $e');
      return 0;
    }
  }

  Future<int> deleteDeck(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'decks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error deleting deck: $e');
      return 0;
    }
  }

  // CARD OPERATIONS
  Future<FlashCard> createCard(FlashCard card) async {
    try {
      final db = await database;
      final id = await db.insert('cards', card.toMap());
      debugPrint('Created card with ID: $id');
      return card.copy(id: id);
    } catch (e) {
      debugPrint('Error creating card: $e');
      rethrow;
    }
  }

  Future<List<FlashCard>> getCardsForDeck(int deckId) async {
    try {
      final db = await database;
      final result = await db.query(
        'cards',
        where: 'deck_id = ?',
        whereArgs: [deckId],
      );

      return result.map((json) => FlashCard.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error getting cards for deck: $e');
      return [];
    }
  }

  Future<int> updateCard(FlashCard card) async {
    try {
      final db = await database;
      return await db.update(
        'cards',
        card.toMap(),
        where: 'id = ?',
        whereArgs: [card.id],
      );
    } catch (e) {
      debugPrint('Error updating card: $e');
      return 0;
    }
  }

  Future<int> deleteAllCardsForDeck(int deckId) async {
    try {
      final db = await database;
      return await db.delete(
        'cards',
        where: 'deck_id = ?',
        whereArgs: [deckId],
      );
    } catch (e) {
      debugPrint('Error deleting all cards for deck: $e');
      return 0;
    }
  }

  Future<int> toggleCardMastery(int cardId, bool isMastered) async {
    try {
      final db = await database;
      return await db.update(
        'cards',
        {'is_mastered': isMastered ? 1 : 0},
        where: 'id = ?',
        whereArgs: [cardId],
      );
    } catch (e) {
      debugPrint('Error toggling card mastery: $e');
      return 0;
    }
  }

  Future<int> deleteCard(int id) async {
    try {
      final db = await database;
      return await db.delete(
        'cards',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error deleting card: $e');
      return 0;
    }
  }

  // Search operations
  Future<List<Deck>> searchDecks(String query) async {
    try {
      final db = await database;
      final decksResult = await db.query(
        'decks',
        where: 'title LIKE ?',
        whereArgs: ['%$query%'],
      );
      
      List<Deck> decks = [];
      for (var deckMap in decksResult) {
        final deckId = deckMap['id'] as int;
        
        // Count total cards
        final countResult = await db.rawQuery(
          'SELECT COUNT(*) as total FROM cards WHERE deck_id = ?', 
          [deckId]
        );
        final cardCount = Sqflite.firstIntValue(countResult) ?? 0;
        
        // Count mastered cards
        final masteredResult = await db.rawQuery(
          'SELECT COUNT(*) as mastered FROM cards WHERE deck_id = ? AND is_mastered = 1', 
          [deckId]
        );
        final masteredCount = Sqflite.firstIntValue(masteredResult) ?? 0;
        
        final deck = Deck.fromMap(deckMap);
        decks.add(deck.copy(
          cardCount: cardCount,
          masteredCount: masteredCount
        ));
      }
      
      return decks;
    } catch (e) {
      debugPrint('Error searching decks: $e');
      return [];
    }
  }

  Future<List<FlashCard>> searchCards(int deckId, String query) async {
    try {
      final db = await database;
      final result = await db.query(
        'cards',
        where: 'deck_id = ? AND (question LIKE ? OR answer LIKE ?)',
        whereArgs: [deckId, '%$query%', '%$query%'],
      );

      return result.map((json) => FlashCard.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error searching cards: $e');
      return [];
    }
  }

  // Utility functions
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}