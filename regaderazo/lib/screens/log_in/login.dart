import 'package:flutter/material.dart';

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
  final Color _primaryColor = ColorSelector.getRed();
  final Color _secondaryColor = ColorSelector.getDarkBlue();
  final Color _tertiaryColor = ColorSelector.getLightBlue();
  final Color _quaternaryColor = ColorSelector.getDarkPink();
  final AssetImage _logo = AssetImage('assets/regaderazo_sin.png');

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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Image(image: _logo, height: MediaQuery.of(context).size.height * 0.15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          LogText(
              context: context,
              tertiaryColor: _quaternaryColor,
              secondaryColor: _secondaryColor,
              icon: Icons.person_outlined,
              text: "Ingresa tu e-mail",
              onChanged: (value) {},
              tailIcon: null,
              obscure: false),
          LogText(
              context: context,
              tertiaryColor: _quaternaryColor,
              secondaryColor: _secondaryColor,
              icon: Icons.lock_outline,
              text: "Ingresa tu password",
              onChanged: (value) {},
              tailIcon: Icons.visibility,
              obscure: true),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          HaveAccount(
              tertiaryColor: null,
              secondaryColor: _secondaryColor,
              text1: "",
              text2: "¿Olvidaste tu contraseña?",
              route: () {
                print("Forgot password");
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          ButtonLog(
              context: context,
              background: _secondaryColor,
              splash: _primaryColor,
              text_color: Colors.white,
              text: "Acceder",
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              }),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          HaveAccount(
              tertiaryColor: _tertiaryColor,
              secondaryColor: _secondaryColor,
              text1: "¿No tienes cuenta?  ",
              text2: "Regístrate",
              route: () {
                Navigator.pushNamed(context, '/sign_up');
              }),
          OrLine(tertiaryColor: _tertiaryColor, context: context),
          SocialLog(
              logo: _tertiaryColor,
              splash: _primaryColor,
              action: () {
                /* BlocProvider.of<AuthBloc>(context).add(
                  GoogleAuthEvent(
                    buildcontext: context,
                  ),
                ); */
                print("HI");
              }),
        ],
      ),
    );
  }
}
