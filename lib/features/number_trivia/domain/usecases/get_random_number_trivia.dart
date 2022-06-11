import 'package:n_trivia/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:n_trivia/core/usecase/usecase.dart';
import 'package:n_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:n_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams>{
  GetRandomNumberTrivia({required this.repository});
  final NumberTriviaRepository repository;
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async{
    return await repository.getRandomNumberTrivia();
  }
  
}