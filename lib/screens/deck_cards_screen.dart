import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../models/deck.dart';
import '../models/flashcard.dart';
import '../screens/create_card_screen.dart';

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
    _cardsFuture = context.read<CardProvider>().getCardsForDeck(widget.deck.id!);
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
        title: Text(widget.deck.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add settings functionality if needed
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
                    return _buildCardItem(card, theme);
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

  Widget _buildCardItem(FlashCard card, ThemeData theme) {
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
              onPressed: () {
                context
                    .read<CardProvider>()
                    .toggleCardMastery(card.id!, !card.isMastered);
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement edit card functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<CardProvider>().deleteCard(card.id!).then((_) {
                  // Reload the cards after deleting a card
                  setState(() {
                    _loadCards();
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}