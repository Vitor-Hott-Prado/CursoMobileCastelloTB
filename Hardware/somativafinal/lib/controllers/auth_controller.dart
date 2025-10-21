import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Retorna usuário atual
  User? get currentUser => _auth.currentUser;

  // Login com email e senha
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Registro com email e senha
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async => await _auth.signOut();
}
