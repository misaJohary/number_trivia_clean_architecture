import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo{
  Future<bool> isConnected();
}

class NetworkInfoImp implements NetworkInfo{
  final InternetConnectionChecker checker;

  NetworkInfoImp(this.checker);
  @override
  Future<bool> isConnected ()  =>  checker.hasConnection;
}

