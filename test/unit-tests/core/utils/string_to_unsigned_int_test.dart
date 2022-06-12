import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:n_trivia/core/utils/string_to_unsigned_int.dart';

void main() {
  late StringToUnsignedInt stringToUnsignedInt;

  setUp(() {
    stringToUnsignedInt = StringToUnsignedInt();
  });
  test('should parse the string to integer', () {
    String str = '123';
    final result = stringToUnsignedInt.inputConverter(str);
    expect(result, const Right(123));
  });

  test('should return InputFailure when the input string is not valid', (){
    String str = '1.0';
    final result = stringToUnsignedInt.inputConverter(str);
    expect(result, Left(InvalidInputFailure()));
  });

  test('should return an InputFailure when the input string is negative', (){
    String str = '-1';
    final result = stringToUnsignedInt.inputConverter(str);
    expect(result, Left(InvalidInputFailure()));
  });
}
