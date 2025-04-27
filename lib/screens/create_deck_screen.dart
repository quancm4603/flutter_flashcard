import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_provider.dart';
import '../components/settings_dialog.dart';

class CreateDeckScreen extends StatefulWidget {
  const CreateDeckScreen({super.key});

  @override
  State<CreateDeckScreen> createState() => _CreateDeckScreenState();
}

class _CreateDeckScreenState extends State<CreateDeckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deckNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _deckNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createDeck() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await context.read<DeckProvider>().addDeck(
            _deckNameController.text.trim(),
            _descriptionController.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create deck')),
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
        title: const Text('Create Deck'),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Deck Name Field
                Text(
                  'Deck Name',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _deckNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter deck name',
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
                      return 'Please enter a deck name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Description Field
                Text(
                  'Description',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Add description (optional)',
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
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                // Instruction Text
                Text(
                  'You can add cards after creating the deck',
                  style: theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                // Add Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _createDeck,
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
                        : const Icon(Icons.add, size: 24),
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