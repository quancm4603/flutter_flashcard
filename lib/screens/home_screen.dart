import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';
import '../providers/theme_provider.dart';
import '../models/deck.dart';
import 'create_deck_screen.dart';

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
              context.read<ThemeProvider>().toggleTheme();
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
          // Deck list
          Expanded(
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
                    return _buildDeckCard(deck, theme);
                  },
                );
              },
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
              value: deck.cardCount > 0
                  ? deck.masteredCount / deck.cardCount
                  : 0,
              backgroundColor: theme.colorScheme.surface,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 8),
            // Deck details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${deck.masteredCount}/${deck.cardCount} cards mastered',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  deck.masteryPercentageFormatted,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Edit and delete buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    context.read<DeckProvider>().deleteDeck(deck.id!);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}