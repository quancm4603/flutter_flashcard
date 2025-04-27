import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';
import '../providers/card_provider.dart';
import '../models/deck.dart';
import 'create_deck_screen.dart';
import 'deck_cards_screen.dart';
import 'edit_deck_screen.dart';
import '../components/settings_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeckProvider>().loadDecks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshDecks() async {
    await context.read<DeckProvider>().loadDecks();
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, Deck deck) async {
    final theme = Theme.of(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Deck',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete the deck "${deck.title}"? This will also delete all associated cards.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      context.read<DeckProvider>().deleteDeck(deck.id!);
      context.read<CardProvider>().deleteAllCardsForDeck(deck.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Decks'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SettingsDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<DeckProvider>().setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search deck',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
              ),
            ),
          ),
          // Deck list with pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDecks,
              child: Consumer<DeckProvider>(
                builder: (context, deckProvider, child) {
                  if (deckProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final decks = deckProvider.decks;
                  if (decks.isEmpty) {
                    return const Center(
                      child: Text('No decks yet. Create your first deck!'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: decks.length,
                    itemBuilder: (context, index) {
                      final deck = decks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeckCardsScreen(deck: deck),
                            ),
                          ).then((_) {
                            // Reload the decks when returning from DeckCardsScreen
                            setState(() {
                              _refreshDecks();
                            });
                          });
                        },
                        child: _buildDeckCard(deck, theme),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateDeckScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDeckCard(Deck deck, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deck title
            Text(
              deck.title,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            // Progress bar
            LinearProgressIndicator(
              value:
                  deck.cardCount > 0 ? deck.masteredCount / deck.cardCount : 0,
              backgroundColor: theme.colorScheme.surface,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 8),
            // Deck details and edit button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${deck.masteredCount}/${deck.cardCount} cards mastered',
                  style: theme.textTheme.bodyMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDeckScreen(deck: deck),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, deck);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}