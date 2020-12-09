import 'package:rxdart/streams.dart';

abstract class Auth {
  ValueStream<String> get token;
  ValueStream<String> get userId;
  ValueStream<bool> get isAuthenticated;

  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);

  Future logout();
}
