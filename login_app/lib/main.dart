import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/screens/login.dart';
import 'package:login_app/screens/splash.dart';
import 'package:login_app/screens/user_menu.dart';

import 'auth_stream.dart';
import 'exceptions/login_exception.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final AuthStream authStream = AuthStream();

  @override
  void dispose() {
    authStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 198, 90, 80),
          background: const Color.fromARGB(255, 241, 209, 207),
        ),
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: StreamBuilder(
        stream: authStream.authControllerStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            switch (snapshot.data) {
              case AuthState.loading:
                return const SplashScreen();
              case AuthState.success:
                return UserMenuScreen(authStream: authStream);
              default:
                return LoginScreen(authStream: authStream);
            }
          }

          if (snapshot.hasError) {
            LoginException exception = snapshot.error as LoginException;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(exception.message),
                ),
              );
            });
          }
          return LoginScreen(authStream: authStream);
        },
      ),
    );
  }
}
