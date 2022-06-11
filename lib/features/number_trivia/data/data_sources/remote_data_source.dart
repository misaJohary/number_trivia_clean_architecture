import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:n_trivia/core/error/exception.dart';

import '../models/number_trivia_model.dart';

abstract class RemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class RemoteDataSourceImp implements RemoteDataSource {
  RemoteDataSourceImp(this.client);
  final http.Client client;
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final res = await client.get(
      Uri.parse('http://numbersapi.com/$number'),
      headers: {'Content-Type': 'application/json'},
    );
    if (res.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(res.body));
    }else{
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    final res = await client.get(
      Uri.parse('http://numbersapi.com/'),
      headers: {'Content-Type': 'application/json'},
    );
    if(res.statusCode == 200){
    return NumberTriviaModel.fromJson(json.decode(res.body));
    }else{
      throw ServerException();
    }
  }
}
