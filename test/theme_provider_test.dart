import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flashcard_app/providers/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    late ThemeProvider themeProvider;

    setUp(() async {
      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      themeProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for async init
    });

    test('Default theme mode should be dark', () {
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('Toggling theme should switch between light and dark', () async {
      // Initial state is dark
      expect(themeProvider.themeMode, ThemeMode.dark);

      // Toggle to light
      await themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.light);

      // Toggle back to dark
      await themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.dark);
    });

    test('Theme mode should persist in SharedPreferences', () async {
      // Toggle to light
      await themeProvider.toggleTheme();
      expect(themeProvider.themeMode, ThemeMode.light);

      // Create a new instance of ThemeProvider
      final newThemeProvider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100)); // Wait for async init

      // Verify the theme mode is restored
      expect(newThemeProvider.themeMode, ThemeMode.light);
    });

    test('notifyListeners should be called after toggling theme', () async {
      bool listenerCalled = false;

      themeProvider.addListener(() {
        listenerCalled = true;
      });

      await themeProvider.toggleTheme();
      expect(listenerCalled, true);
    });
  });
}