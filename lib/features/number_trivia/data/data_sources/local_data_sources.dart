import 'dart:convert';

import 'package:n_trivia/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class LocalDataSource{
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia);
}

class LocalDataSourceImp implements LocalDataSource{
  LocalDataSourceImp({required this.sharedPreferences});
  final SharedPreferences sharedPreferences; 
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivia) {
    final result = sharedPreferences.setString('NUMBER_TRIVIA', json.encode(numberTrivia.toJson()));
    return result;
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final result = sharedPreferences.getString('NUMBER_TRIVIA');
    if(result != null){
      return Future.value(NumberTriviaModel.fromJson(json.decode(result)));
    } else{
      throw CacheException();
    }

    
  }

}