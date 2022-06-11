import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:n_trivia/core/network/network_info.dart';

import 'network_info_imp_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImp networkInfoImp;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImp = NetworkInfoImp(mockInternetConnectionChecker);
  });

  test('should return the status of the network', () async{
    // arrange
    // Future<bool> tAnswer = Future.value(true);
    when(mockInternetConnectionChecker.hasConnection)
        .thenAnswer((_) async => true);

    //act
    final result = await networkInfoImp.isConnected();

    //assert
    expect(result, equals(true));
  });
}
