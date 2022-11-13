import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regaderazo/screens/home_page.dart';

import 'auth/bloc/auth_bloc.dart';
import 'bloc/bloc/users_bloc.dart';
import 'screens/account.dart';
import 'screens/log_in/login.dart';
import 'screens/numbers.dart';
import 'screens/report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(VerifyAuthEvent()),
        ),
        BlocProvider(
          create: (context) => UsersBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
        ),
      ),
      routes: {
        '/login': (context) => LogInForm(),
        '/report': (context) => Report(),
        '/home': (context) => HomePage(),
        '/account': (context) => Account(),
        '/numbers': (context) => Numbers(),
      },
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState ||
              state is AuthErrorState ||
              state is SignOutSuccessState) {
            return LogInForm();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}