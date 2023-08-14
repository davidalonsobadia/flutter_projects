import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_app/exceptions/sign_in_exceptions.dart';
import 'package:login_app/services/login_backend_client.dart';

import 'models/user_data.dart';

class AuthStream {
  final _auth = FirebaseAuth.instance;

  final StreamController<AuthState> _authController = StreamController<AuthState>();

  Stream<AuthState> get authControllerStream => _authController.stream;

  AuthStream() {
    _authController.add(AuthState.initial);
  }

  void dispose() {
    _authController.close();
  }

  Future<void> signInWithGoogle() async {
    try {
      _authController.add(AuthState.loading);
      await signInWithProviderAndRegisterUser();
      _authController.add(AuthState.success);
    } catch (exception) {
      _authController.addError(exception);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      _authController.add(AuthState.loading);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _authController.add(AuthState.success);
    } on FirebaseAuthException catch (exception) {
      EmailPasswordSignInException emailPasswordException;
      if (exception.message != null) {
        emailPasswordException = EmailPasswordSignInException(exception.message!);
      } else {
        emailPasswordException = EmailPasswordSignInException(
            'There was an error when siging in with Email and Password. Please try again later.');
      }
      _authController.addError(emailPasswordException);
    }
  }

  Future<void> signInWithProviderAndRegisterUser() async {
    late String name, email, uid;
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        throw GoogleSignInException(
            'Error when connecting with Google Sign In Service. Please try again later');
      }

      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

      var result = (await _auth.signInWithCredential(credential));
      uid = result.user!.uid;
      email = googleSignInAccount.email;
      name = googleSignInAccount.displayName ?? 'user_name_not_provided';
    } catch (exception) {
      throw GoogleSignInException(
          'Error when Signing in Google Credentials. Please contact your administrator.');
    }

    try {
      final userData = UserData(id: uid, name: name, email: email, provider: 'google');
      LoginBackendClient loginBackendClient = LoginBackendClient('10.0.2.2:5000');
      final response = await loginBackendClient.registerUser(userData);

      if (response.statusCode != 201 && response.statusCode != 200) {
        _auth.signOut();
        throw UserRegistrationException('Error when registrating the user in our Database. ${response.body}');
      }
    } on Exception catch (_) {
      _auth.signOut();
      throw UserRegistrationException('Error when registrating the user in our Database. Try again later');
    }
  }

  void signOut() {
    _auth.signOut();
    _authController.add(AuthState.initial);
  }
}

enum AuthState { initial, loading, success }
