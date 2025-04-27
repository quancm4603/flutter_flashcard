import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/deck.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE decks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deck_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (deck_id) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
  }

  // DECK OPERATIONS
  Future<Deck> createDeck(Deck deck) async {
    final db = await database;
    final id = await db.insert('decks', deck.toMap());
    return deck.copy(id: id);
  }

  Future<List<Deck>> getAllDecks() async {
    final db = await database;
    
    // Get all decks
    final decksResult = await db.query('decks', orderBy: 'created_at DESC');
    
    // Get card counts for each deck
    List<Deck> decks = [];
    for (var deckMap in decksResult) {
      final deckId = deckMap['id'] as int;
      final countResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM cards WHERE deck_id = ?', 
        [deckId]
      );
      final cardCount = Sqflite.firstIntValue(countResult) ?? 0;
      
      final deck = Deck.fromMap(deckMap);
      decks.add(deck.copy(cardCount: cardCount));
    }
    
    return decks;
  }

  Future<int> updateDeck(Deck deck) async {
    final db = await database;
    return db.update(
      'decks',
      deck.toMap(),
      where: 'id = ?',
      whereArgs: [deck.id],
    );
  }

  Future<int> deleteDeck(int id) async {
    final db = await database;
    return await db.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Add other necessary methods for cards and decks
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}