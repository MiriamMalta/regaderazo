import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/bloc/auth_bloc.dart';
import 'blocs/temperature/bloc/temperature_bloc.dart';
import 'blocs/users/bloc/users_bloc.dart';

import 'screens/account.dart';
import 'screens/account2.dart';
import 'screens/home_page.dart';
import 'screens/home_page2.dart';
import 'screens/log_in/login.dart';
import 'screens/numbers.dart';
import 'screens/profiles_page.dart';
import 'screens/report.dart';
import 'screens/report2.dart';

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
        BlocProvider(
          create: (context) => TemperatureBloc(),
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
        '/home': (context) => HomePage(),
        '/home2': (context) => HomePage2(
          profiles: [],
        ),
        '/account': (context) => Account(),
        '/account2': (context) => Account2(
          profiles: [],
        ),
        '/numbers': (context) => Numbers(),
        '/profiles': (context) => ProfilesPage(),
        '/report': (context) => Report(),
        '/report2': (context) => Report2(
          profiles: [],
        ),
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
            return ProfilesPage(); //HomePage //ProfilesPage
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