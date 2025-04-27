import 'package:flashcard_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'providers/theme_provider.dart';
import 'providers/deck_provider.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // This catches errors that happen during Flutter initialization
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
  };

  // Handles errors that occur in the zone where the Flutter application runs
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('App initialized');

    try {
      if (kIsWeb) {
        debugPrint('Setting up web database');
        databaseFactory = databaseFactoryFfiWeb;
      } else {
        debugPrint('Setting up mobile database');
        // For Android & iOS
        // No setup needed for regular SQLite on mobile
      }

      // Initialize your app
      runApp(const MyApp());
    } catch (error, stackTrace) {
      debugPrint('Error during startup: $error');
      debugPrint(stackTrace.toString());
    }
  }, (error, stackTrace) {
    debugPrint('Uncaught error: $error');
    debugPrint(stackTrace.toString());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DeckProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flashcard App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
            // Add error handling for widget errors
            builder: (context, widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Something went wrong!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorDetails.exception.toString(),
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              };
              return widget!;
            },
          );
        },
      ),
    );
  }
}