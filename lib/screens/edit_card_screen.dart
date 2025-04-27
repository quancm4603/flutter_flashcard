import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/card_provider.dart';
import '../models/flashcard.dart';

class EditCardScreen extends StatefulWidget {
  final FlashCard card;

  const EditCardScreen({super.key, required this.card});

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _definitionController;
  late TextEditingController _meaningController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _definitionController = TextEditingController(text: widget.card.question);
    _meaningController = TextEditingController(text: widget.card.answer);
  }

  @override
  void dispose() {
    _definitionController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  Future<void> _editCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedCard = widget.card.copy(
        question: _definitionController.text.trim(),
        answer: _meaningController.text.trim(),
      );
      await context.read<CardProvider>().updateCard(updatedCard);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update card')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Card'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Definition Field
                Text(
                  'Definition',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _definitionController,
                  maxLength: 100,
                  decoration: InputDecoration(
                    hintText: 'Enter the word or phrase',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a definition';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Meaning Field
                Text(
                  'Meaning',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _meaningController,
                  maxLength: 500,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter the explanation or translation',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a meaning';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _editCard,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}