import 'package:n_trivia/core/error/exception.dart';
import 'package:n_trivia/features/number_trivia/data/data_sources/local_data_sources.dart';
import 'package:n_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:n_trivia/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:n_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/network/network_info.dart';
import '../data_sources/remote_data_source.dart';

class NumberTriviaRepositoryImp extends NumberTriviaRepository {
  NumberTriviaRepositoryImp({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteTrivia =
            await remoteDataSource.getConcreteNumberTrivia(number);
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected()) {
      try {
        final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
        await localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cacheTrivia = await localDataSource.getLastNumberTrivia();
        return Right(cacheTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
