// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MockitoGenerator
// **************************************************************************

import 'dart:async' as i4;

import 'package:flashcard_app/models/flashcard.dart' as i5;
import 'package:flashcard_app/providers/card_provider.dart' as i3;
import 'package:mockito/mockito.dart' as i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class MockCardProvider extends i1.Mock implements i3.CardProvider {
  MockCardProvider() {
    i1.throwOnMissingStub(this);
  }

  @override
  i4.Future<List<i5.FlashCard>> getCardsForDeck(int? deckId) =>
      (super.noSuchMethod(
        Invocation.method(#getCardsForDeck, [deckId]),
        returnValue: Future<List<i5.FlashCard>>.value(<i5.FlashCard>[]),
      ) as i4.Future<List<i5.FlashCard>>);
  @override
  i4.Future<void> deleteCard(int? cardId) => (super.noSuchMethod(
        Invocation.method(#deleteCard, [cardId]),
        returnValue: Future<void>.value(),
        returnValueForMissingStub: Future<void>.value(),
      ) as i4.Future<void>);
  @override
  i4.Future<void> toggleCardMastery(int? cardId, bool? isMastered) =>
      (super.noSuchMethod(
        Invocation.method(#toggleCardMastery, [cardId, isMastered]),
        returnValue: Future<void>.value(),
        returnValueForMissingStub: Future<void>.value(),
      ) as i4.Future<void>);
}
