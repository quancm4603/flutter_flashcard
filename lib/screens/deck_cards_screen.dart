import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../screens/create_card_screen.dart';
import '../screens/study_mode_screen.dart';
import '../screens/edit_card_screen.dart';
import '../components/settings_dialog.dart';

class DeckCardsScreen extends StatefulWidget {
  final Deck deck;

  const DeckCardsScreen({super.key, required this.deck});

  @override
  State<DeckCardsScreen> createState() => _DeckCardsScreenState();
}

class _DeckCardsScreenState extends State<DeckCardsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<FlashCard>> _cardsFuture;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  void _loadCards() {
    _cardsFuture =
        context.read<CardProvider>().getCardsForDeck(widget.deck.id!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, FlashCard card) async {
    final theme = Theme.of(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Card',
          style: theme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete this card? This action cannot be undone.',
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
      await context.read<CardProvider>().deleteCard(card.id!);
      setState(() {
        _loadCards();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.title),
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
                // Implement search functionality
              },
              decoration: InputDecoration(
                hintText: 'Search cards',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
              ),
            ),
          ),
          // Cards list
          Expanded(
            child: FutureBuilder<List<FlashCard>>(
              future: _cardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load cards'));
                }

                final cards = snapshot.data ?? [];
                if (cards.isEmpty) {
                  return const Center(
                    child: Text('No cards yet. Add your first card!'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return _buildCardItem(card, theme, cards);
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
              builder: (context) => CreateCardScreen(deck: widget.deck),
            ),
          ).then((_) {
            // Reload the cards when returning from the CreateCardScreen
            setState(() {
              _loadCards();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCardItem(
      FlashCard card, ThemeData theme, List<FlashCard> cards) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          card.question,
          style: theme.textTheme.bodyLarge,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                card.isMastered ? Icons.star : Icons.star_border,
                color: theme.colorScheme.secondary,
              ),
              onPressed: () async {
                await context
                    .read<CardProvider>()
                    .toggleCardMastery(card.id!, !card.isMastered);
                setState(() {
                  _loadCards(); // Reload the cards after toggling mastery
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCardScreen(card: card),
                  ),
                ).then((_) {
                  // Reload the cards after editing a card
                  setState(() {
                    _loadCards();
                  });
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, card);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudyModeScreen(
                cards: cards,
                initialIndex: cards.indexOf(card),
              ),
            ),
          ).then((_) {
            // Reload the cards when returning from the StudyModeScreen
            setState(() {
              _loadCards();
            });
          });
        },
      ),
    );
  }
}