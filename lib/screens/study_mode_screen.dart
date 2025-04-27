import 'package:flutter/material.dart';
import '../models/flashcard.dart';
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _isFront ? card.question : card.answer,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
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