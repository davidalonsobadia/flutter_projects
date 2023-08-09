import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:login_app/screens/signup.dart';

import '../models/user_data.dart';
import '../services/login_backend_client.dart';
import '../widgets/decoration.dart';

final _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;

  void _signInWithGoogle() async {
    setState(() {
      _isAuthenticating = true;
    });

    late String name, email, uid;

    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('error getting google sign in account');
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);

      var result = (await _auth.signInWithCredential(credential));
      uid = result.user!.uid;
      email = googleSignInAccount.email;
      name = googleSignInAccount.displayName ?? 'user_name_not_provided';
    } catch (e) {
      clearAndShowSnackBar(context, 'Google Sign in Failed');
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }

    try {
      // All this code that is executed after _auth.signInWithCredential, will be executed when the auth
      // state changes, then the mounted tree of the Wdigets have changed as well.
      // We need to find another solution to handle errors and this code when authstate changes. Otherwise
      // we could end up in an undesired state
      final userData = UserData(id: uid, name: name, email: email, provider: 'google');
      LoginBackendClient loginBackendClient = LoginBackendClient('10.0.2.2:5000');
      final response = await loginBackendClient.registerUser(userData);

      // these checks and handled errors are wrong, since the widget tree will have changed when the code reaches that point

      if (response.statusCode != 201 && response.statusCode != 200) {
        _auth.signOut();
        clearAndShowSnackBar(
            context, 'Something went wrong when creating your user. Please try again later.');
        return;
      }
    } on Exception catch (_) {
      _auth.signOut();
      setState(() {
        _isAuthenticating = false;
      });
      clearAndShowSnackBar(context, 'Authentication failed.');
    }

    return;
  }

  void _signInWithEmailAndPassword() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      // show error message
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isAuthenticating = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/mylogo-removebg.png'),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _form,
                  child: Column(children: [
                    Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: textFormFieldInputDecoration(hintText: 'Email'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      decoration: textFormFieldInputDecoration(hintText: 'Password'),
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPassword = value!;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add your navigation logic here
                        print('Forgot your password clicked');
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Color.fromARGB(255, 1, 5, 8),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: _signInWithEmailAndPassword,
                      child: const Text('Login'),
                    ),
                  ]),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      width: 70.0,
                      height: 1.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('or log in with'),
                    ),
                    Container(
                      color: Colors.black,
                      width: 70.0,
                      height: 1.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Icon(Bootstrap.google),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Icon(Bootstrap.apple),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Icon(Bootstrap.linkedin),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const SignUpScreen()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Color.fromARGB(255, 1, 5, 8),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (_isAuthenticating) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: content,
    );
  }
}
