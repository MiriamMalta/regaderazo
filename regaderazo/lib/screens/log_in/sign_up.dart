import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/colors.dart';
import 'parts/button_log.dart';
import 'parts/have_account.dart';
import 'parts/log_text.dart';
import 'parts/or_line.dart';
import 'parts/social_log.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final Color _primaryColor = ColorSelector.getRRed();
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
          Image(
            image: _logo,
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          LogText(
              context: context,
              secondaryColor: _secondaryColor,
              icon: Icons.person_outlined,
              text: "Ingresa tu e-mail",
              onChanged: (value) {},
              tailIcon: null,
              obscure: false),
          LogText(
              context: context,
              secondaryColor: _secondaryColor,
              icon: Icons.lock_outline,
              text: "Ingresa tu password",
              onChanged: (value) {},
              tailIcon: Icons.visibility,
              obscure: true),
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
              text1: "¿Ya tienes cuenta?  ",
              text2: "Inicia sesión",
              route: () {
                Navigator.pushNamed(context, '/login');
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
                print("HI!");
              }),
        ],
      ),
    );
  }
}
