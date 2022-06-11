import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:n_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:n_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:n_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia getConcreteNumberTrivia;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcreteNumberTrivia =
        GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });
  int tNumber = 1;
  final NumberTrivia tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test('should get trivia for the number from the repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(tNumberTrivia));

    //act
    final result = await getConcreteNumberTrivia(Params(number: tNumber));

    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
