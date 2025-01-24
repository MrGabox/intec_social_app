import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Registro de usuario
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error en el registro: ${e.message}');
      return null;
    }
  }

  // Inicio de sesión de usuario
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error en el inicio de sesión: ${e.message}');
      return null;
    }
  }

  // Inicio de sesión con Google
  Future<User?> loginWithGoogle() async {
    try {
      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print('Error en inicio de sesión con Google: $e');
      return null;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  // Recuperación de contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Correo de recuperación enviado a $email');
    } catch (e) {
      print('Error en la recuperación de contraseña: $e');
    }
  }

  // Verificación del estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}