import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:n_trivia/core/usecase/usecase.dart';
import 'package:n_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:n_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failure.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params>{
  GetConcreteNumberTrivia({required this.repository});
  final NumberTriviaRepository repository;
  @override
  Future<Either<Failure, NumberTrivia>> call(Params params)async{
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  const Params({required this.number});
  final int number;
  
  @override
  List<Object?> get props => [number];
} 