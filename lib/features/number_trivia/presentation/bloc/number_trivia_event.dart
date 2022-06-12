part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent{
  const GetTriviaForConcreteNumber(this.inputNumber);
  final String inputNumber;

  @override
  List<Object> get props => [inputNumber];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent{

}
