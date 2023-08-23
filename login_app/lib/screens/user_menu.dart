import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:login_app/auth_cubit.dart';

import '../models/user_data.dart';
import '../services/login_backend_client.dart';

final _auth = FirebaseAuth.instance;

class UserMenuScreen extends StatefulWidget {
  const UserMenuScreen({super.key});

  @override
  State<UserMenuScreen> createState() => _UserMenuScreenState();
}

class _UserMenuScreenState extends State<UserMenuScreen> {
  UserData? _userData;
  String? _error;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    LoginBackendClient loginBackendClient = LoginBackendClient('10.0.2.2:5000');
    var idToken = await _auth.currentUser!.getIdToken();

    try {
      final userData = await loginBackendClient.getUserByIdToken(idToken!);

      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Failed to fetch data, please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No data from the user...'));

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      content = Center(child: Text(_error!));
    }

    if (_userData != null) {
      String date = DateFormat("EEEE dd MMMM yyyy").format(DateTime.now());
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello', style: Theme.of(context).textTheme.bodyLarge!),
                Text(
                  _userData!.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text('Today is $date', style: Theme.of(context).textTheme.bodyLarge!),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 246, 232, 232),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: context.read<AuthCubit>().signOut,
            icon: const Icon(Icons.exit_to_app),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: content,
    );
  }
}
