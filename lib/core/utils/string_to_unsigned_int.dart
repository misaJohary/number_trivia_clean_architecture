import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:n_trivia/core/error/failure.dart';

class StringToUnsignedInt extends Equatable {
  Either<Failure, int> inputConverter(String input) {
    try {
      final res = int.parse(input);
      if(res < 0){
        throw const FormatException();
      }
      return Right(res);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}

class InvalidInputFailure extends Failure {}
