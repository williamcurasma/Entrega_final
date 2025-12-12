import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTRO CON EMAIL
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("❌ Error en registro: ${e.code} - ${e.message}");
      return null;
    }
  }

  // LOGIN CON EMAIL
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("❌ Error en login: ${e.code} - ${e.message}");
      return null;
    }
  }

  // LOGIN CON GOOGLE - VERSIÓN SIMPLIFICADA (sin google_sign_in)
  Future<User?> signInWithGoogle() async {
    print("⚠️ Google Sign-In no disponible temporalmente");
    return null;
  }

  // CERRAR SESIÓN
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("✅ Sesión cerrada exitosamente");
    } catch (error) {
      print("❌ Error al cerrar sesión: $error");
    }
  }

  // USUARIO ACTUAL
  User? get currentUser => _auth.currentUser;

  // STREAM DE CAMBIOS
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}