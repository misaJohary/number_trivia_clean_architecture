part of 'number_trivia_bloc.dart';

enum Status { init, loading, loaded, error }

abstract class NumberTriviaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  Loaded({required this.numberTrivia});
  final NumberTrivia numberTrivia;

  @override
  List<Object?> get props => [numberTrivia];
}

class Error extends NumberTriviaState {
  Error(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

// enum Status { init, loading, loaded, error }

// class NumberTriviaState extends Equatable {
//   const NumberTriviaState({
//     required this.status,
//     this.errorMessage,
//     required this.numberTrivia,
//   });

//   final Status status;
//   final String? errorMessage;
//   final NumberTrivia numberTrivia;

//   @override
//   List<Object?> get props => [
//         status,
//         errorMessage,
//         numberTrivia,
//       ];
// }
