abstract class Auth {
  Stream<String> get token;
  Stream<String> get userId;
  Stream<bool> get isAuthenticated;

  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);

  Future logout();
}
