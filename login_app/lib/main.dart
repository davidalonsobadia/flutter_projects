import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/business_logic/auth/auth_cubit.dart';
import 'package:login_app/screens/login.dart';
import 'package:login_app/screens/splash.dart';
import 'package:login_app/screens/user_menu.dart';

import 'business_logic/auth/auth_state.dart';
import 'services/exceptions/login_exception.dart';
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
      home: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          if (state is LoadingState) {
            return const SplashScreen();
          } else if (state is SuccessState) {
            return const UserMenuScreen();
          } else if (state is ErrorState) {
            LoginException exception = state.exception as LoginException;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(exception.message),
                ),
              );
            });
          }
          return const LoginScreen();
        }),
      ),
    );
  }
}
