import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:n_trivia/core/error/exception.dart';
import 'package:n_trivia/core/error/failure.dart';
import 'package:n_trivia/core/network/network_info.dart';
import 'package:n_trivia/features/number_trivia/data/data_sources/local_data_sources.dart';
import 'package:n_trivia/features/number_trivia/data/data_sources/remote_data_source.dart';
import 'package:n_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:n_trivia/features/number_trivia/data/repositories/number_trivia_repository_imp.dart';
import 'package:n_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_imp_test.mocks.dart';

@GenerateMocks([LocalDataSource])
@GenerateMocks([RemoteDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  late NumberTriviaRepositoryImp numberTriviaRepositoryImp;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepositoryImp = NumberTriviaRepositoryImp(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  const NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(text: 'Test text', number: 1);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;
  const tNumber = 1;

  // void runTestOnLine(String description, Function body) {
  //   test(description, () {
  //     when(mockNetworkInfo.isConnected)
  //         .thenAnswer((_) async => Future.value(true));
  //     body();
  //   });
  // }

  group('Online', () {
    // runTestOnLine('should check if the device is online', ()async{
    //   when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
    //       .thenAnswer((_) async => tNumberTriviaModel);
    //   //act
    //   await numberTriviaRepositoryImp.getConcreteNumberTrivia(tNumber);
    //   //assert
    //   verify(mockNetworkInfo.isConnected);
    // });

    setUp(
      () {
        when(mockNetworkInfo.isConnected())
            .thenAnswer((_) async => Future.value(true));
      },
    );
    test('should check if the return value is tNumberTriviaModel', () async {
      //Arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result =
          await numberTriviaRepositoryImp.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, const Right(tNumberTriviaModel));
      verify(mockNetworkInfo.isConnected());
    });

    test('should check if the numberTrivia is cached', () async {
      //Arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => tNumberTriviaModel);
      // when(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      //act
      final result =
          await numberTriviaRepositoryImp.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, const Right(tNumberTriviaModel));
      verify(mockNetworkInfo.isConnected());
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });

    test('should return server exception when an error occured', () async {
      //arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenThrow(ServerException());

      //act
      final result =
          await numberTriviaRepositoryImp.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });

    test('should check if the return value is tNumberTrivia', () async {
      //Arrange
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      //act
      final result = await numberTriviaRepositoryImp.getRandomNumberTrivia();

      //assert
      expect(result, equals(const Right(tNumberTriviaModel)));
    });

    test('should cache the numbertrivia', () async {
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      final result = await numberTriviaRepositoryImp.getRandomNumberTrivia();
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      verify(mockRemoteDataSource.getRandomNumberTrivia());
    });

    test('should throw a server exception when an error occured', () async {
      //Arrange
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());

      //act
      final result = await numberTriviaRepositoryImp.getRandomNumberTrivia();

      //assert
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, Left(ServerFailure()));
    });
  });

  group('Offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected())
          .thenAnswer((_) async => Future.value(false));
    });

    test('shouldn\'t call the remote data source when the device is offline',
        () async {
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      await numberTriviaRepositoryImp.getConcreteNumberTrivia(tNumber);

      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
    });
    test('should return the last number trivia when it\'s offline', () async {
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      final result =
          await numberTriviaRepositoryImp.getConcreteNumberTrivia(tNumber);
      expect(result, const Right(tNumberTriviaModel));
    });

    test('should return a cache exception when an error occured', () async {
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

      final result =
          await numberTriviaRepositoryImp.getConcreteNumberTrivia(tNumber);

      expect(result, equals(Left<Failure, NumberTrivia>(CacheFailure())));
    });

    test('shouldn\'t call the remote data source', () async {
      //arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      //act
      final result = await numberTriviaRepositoryImp.getRandomNumberTrivia();

      //Assert
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return the last cached number trivia', () async {
      //arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      //act
      final result = await numberTriviaRepositoryImp.getRandomNumberTrivia();

      //Assert
      verifyZeroInteractions(mockRemoteDataSource);
      expect(result, const Right(tNumberTriviaModel));
    });

    test(
        'should return cache error when the last number trivia can\'t be taken',
        () async {
      //arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

      //act
      final result = await numberTriviaRepositoryImp.getRandomNumberTrivia();

      //assert
      expect(result, Left(CacheFailure()));
    });
  });
}
