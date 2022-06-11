import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:n_trivia/core/error/exception.dart';
import 'package:n_trivia/features/number_trivia/data/data_sources/remote_data_source.dart';
import 'package:n_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../../fixtures/fixture_reader.dart';
import 'remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late RemoteDataSourceImp remoteDataSource;

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = RemoteDataSourceImp(mockClient);
  });

  const tNumber = 1;
  const tNumberTriviaModel = NumberTriviaModel(text: "Test Text", number: 1);
  group('get Concrete number trivia', () {
    test(
        'should perform a get request on an url being called with the the number to retrieve',
        () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      //act
      remoteDataSource.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test(
        'should return the numbertrivia form remote when the response is success 2OO',
        () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      //act
      final res = await remoteDataSource.getConcreteNumberTrivia(tNumber);

      //assert
      expect(
          res, NumberTriviaModel.fromJson(json.decode(fixture('trivia.json'))));
    });

    test('should throw a ServerException when the response status code is 404',
        () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Failure', 404));

      //act
      final call = remoteDataSource.getConcreteNumberTrivia;

      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('get Random number trivia', () {
    test(
        'should perform a get request on an url being called',
        () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      //act
      remoteDataSource.getRandomNumberTrivia();

      //assert
      verify(mockClient.get(
        Uri.parse('http://numbersapi.com/'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test(
        'should return the numbertrivia form remote when the response is success 2OO',
        () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));

      //act
      final res = await remoteDataSource.getRandomNumberTrivia();

      //assert
      expect(
          res, NumberTriviaModel.fromJson(json.decode(fixture('trivia.json'))));
    });

    test('should throw a ServerException when the response status code is 404',
        () async {
      //arrange
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Failure', 404));

      //act
      final call = remoteDataSource.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
