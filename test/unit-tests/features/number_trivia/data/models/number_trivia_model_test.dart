import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:n_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:n_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
  final tJsonNumberTrivia = {'number': 1, 'text': 'Test Text'};

  test('Should be a subclass of the number trivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  group('from json', () {
    test('from json with an integer number', () async {
      final result =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
      expect(result, tNumberTriviaModel);
    });

    test('from json with a double number', () async {
      final result =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia_double.json')));
      expect(result, tNumberTriviaModel);
    });
  });

  test('toJson', () async {
    final result = tNumberTriviaModel.toJson();
    expect(result, tJsonNumberTrivia);
  });
}
