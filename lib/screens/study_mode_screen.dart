import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/flashcard.dart';
import '../providers/card_provider.dart';
import '../components/settings_dialog.dart';

class StudyModeScreen extends StatefulWidget {
  final List<FlashCard> cards;
  final int initialIndex;

  const StudyModeScreen({
    super.key,
    required this.cards,
    this.initialIndex = 0,
  });

  @override
  State<StudyModeScreen> createState() => _StudyModeScreenState();
}

class _StudyModeScreenState extends State<StudyModeScreen> {
  late int _currentIndex;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _flipCard() {
    setState(() {
      _isFront = !_isFront;
    });
  }

  void _goToNextCard() {
    if (_currentIndex < widget.cards.length - 1) {
      setState(() {
        _currentIndex++;
        _isFront = true;
      });
    }
  }

  void _goToPreviousCard() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _isFront = true;
      });
    }
  }

  Future<void> _toggleMastery(FlashCard card) async {
    await context
        .read<CardProvider>()
        .toggleCardMastery(card.id!, !card.isMastered);
    setState(() {
      widget.cards[_currentIndex] =
          card.copy(isMastered: !card.isMastered); // Update the card locally
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = widget.cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Mode'),
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
          // Progress and title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card ${_currentIndex + 1} of ${widget.cards.length}',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  card.question,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              value: (_currentIndex + 1) / widget.cards.length,
              backgroundColor: theme.colorScheme.surface,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          // Flashcard
          Expanded(
            child: GestureDetector(
              onTap: _flipCard,
              child: Card(
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _isFront ? card.question : card.answer,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                    ),
                    // Star button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: Icon(
                          card.isMastered ? Icons.star : Icons.star_border,
                          color: theme.colorScheme.secondary,
                        ),
                        onPressed: () => _toggleMastery(card),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goToPreviousCard,
                ),
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  onPressed: () {
                    // Shuffle cards functionality (optional)
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: _goToNextCard,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}