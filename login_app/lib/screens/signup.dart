import 'package:flutter/material.dart';
import 'package:login_app/services/login_backend_client.dart';
import '../models/user_data.dart';
import '../widgets/decoration.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _isAuthenticating = false;
  var _isRegisteredDone = false;

  void _createUser() async {
    setState(() {
      _isAuthenticating = true;
    });

    final isValid = _form.currentState!.validate();

    if (!isValid) {
      // show error message if needed, because there are already message validations shown
      return;
    }

    _form.currentState!.save();

    try {
      // Send user name and regiter details to backend to register user there.
      // The IP to connect to a localhost server is: 10.0.2.2
      final userData = UserData(
          name: _enteredName,
          email: _enteredEmail,
          password: _enteredPassword,
          provider: 'email_and_password');
      LoginBackendClient loginBackendClient = LoginBackendClient('10.0.2.2:5000');
      final response = await loginBackendClient.registerUser(userData);

      if (!context.mounted) {
        return;
      }

      if (response.statusCode != 201) {
        clearAndShowSnackBar(
            context, 'Something went wrong when creating your user. Please try again later.');
        setState(() {
          _isRegisteredDone = true;
        });
        return;
      }

      clearAndShowSnackBar(context, 'User with email $_enteredEmail was successfully registered!');
      setState(() {
        _isRegisteredDone = true;
      });
    } on Exception catch (_) {
      clearAndShowSnackBar(context, 'Signup failed.');
      setState(() {
        _isAuthenticating = false;
        _isRegisteredDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isRegisteredDone) {
      Navigator.of(context).pop();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      Text(
                        'Sign up',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        enableSuggestions: false,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        decoration: textFormFieldInputDecoration(hintText: 'Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty || value.trim().length < 2) {
                            return 'Please enter a valid name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredName = value!;
                        },
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
                      if (_isAuthenticating) const CircularProgressIndicator(),
                      if (!_isAuthenticating)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          onPressed: _createUser,
                          child: const Text('Sign up'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
