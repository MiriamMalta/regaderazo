import 'package:flutter/material.dart';

import '../../config/colors.dart';
import 'parts/button_log.dart';

class Account extends StatefulWidget {
  Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
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
          ButtonLog(
              context: context,
              background: _secondaryColor,
              splash: _primaryColor,
              text_color: _quaternaryColor,
              text: "Iniciar sesión",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/log_in',
                );
              }),
          ButtonLog(
              context: context,
              background: _primaryColor,
              splash: _secondaryColor,
              text_color: _tertiaryColor,
              text: "Regístrate",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/sign_up',
                );
              }),
        ],
      ),
    );
  }
}
