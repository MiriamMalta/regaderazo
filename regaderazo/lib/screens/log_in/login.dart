import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../config/colors.dart';
import 'parts/button_log.dart';
import 'parts/have_account.dart';
import 'parts/log_text.dart';
import 'parts/or_line.dart';
import 'parts/social_log.dart';

class LogInForm extends StatefulWidget {
  LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final Color _blue = ColorSelector.getRBlue();
  final Color _red = ColorSelector.getRRed();
  final Color _grey = ColorSelector.getDarkGrey();
  final AssetImage _logo = AssetImage('assets/regaderazo_sin.png');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var iniciar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _inside(),
    );
  }

  Container _inside() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _image(),
          _title(),
          _subtitle(),
          LogText(
            context: context,
            secondaryColor: _blue,
            icon: Icons.person_outlined,
            text: "Ingresa tu e-mail",
            onChanged: (value) {},
            tailIcon: null,
            obscure: false
          ),
          LogText(
            context: context,
            secondaryColor: _blue,
            icon: Icons.lock_outline,
            text: "Ingresa tu password",
            onChanged: (value) {},
            tailIcon: Icons.visibility,
            obscure: true
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          _password(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          ButtonLog(
              context: context,
              background: _red,
              splash: _blue,
              text_color: Colors.white,
              text: "Acceder",
              onPressed: () {
                Navigator.pushNamed(context, '/report');
              }
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          _reg_or_inic(),
          OrLine(tertiaryColor: _grey, context: context),
          SocialLog(
            logo: _blue,
            splash: _blue,
            action: () {
              BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
            }
          ),
        ],
      ),
    );
  }

  Widget _image () {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.06,
        bottom: MediaQuery.of(context).size.height * 0.04
      ),
      child: Image(
        image: _logo, 
        height: MediaQuery.of(context).size.height * 0.2
      ),
    );
  }

  Widget _title () {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
        bottom: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Text(
        "Iniciar sesión",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _subtitle () {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
        bottom: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Text(
        "Hola! Favor de ingresar tu cuenta",
        style: TextStyle(
          fontSize: 16,
          color: _grey,
        ),
      ),
    );
  }

  Widget _password () {
    if (iniciar == true) {
      return HaveAccount(
        tertiaryColor: null,
        secondaryColor: _grey,
        text1: "",
        text2: "¿Olvidaste tu contraseña?",
        route: () {
          print("Forgot password");
        }
      );
    }
    else {
      return Container();
    }
  }

  Widget _reg_or_inic () {
    if (iniciar == true) {
      return HaveAccount(
        tertiaryColor: _grey,
        secondaryColor: _red,
        text1: "¿No tienes cuenta?  ",
        text2: "Regístrate",
        route: () {
          setState(() {
            iniciar = false;
          });
        }
      );
    }
    else {
      return HaveAccount(
        tertiaryColor: _grey,
        secondaryColor: _red,
        text1: "¿Ya tienes cuenta?  ",
        text2: "Iniciar sesión",
        route: () {
          setState(() {
            iniciar = true;
          });
        }
      );
    }
  }
}
