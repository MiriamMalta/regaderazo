
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLog extends StatelessWidget {
  const SocialLog({
    Key? key,
    required Color logo,
    required Color splash,
    required Function() action,
  }) : _logo = logo, 
      _splash = splash,
      _action = action,
      super(key: key);

  final Color _logo;
  final Color _splash;
  final Function() _action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        /* GestureDetector(
          onTap: _action,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _tertiaryColor,
                width: 1,
              ),
            ),
            child: FaIcon(
              FontAwesomeIcons.google,
              color: _tertiaryColor,
            ),
          ),
        ), */
        FloatingActionButton(
          heroTag: "btn3",
          backgroundColor: Colors.grey[50],
          splashColor: _splash,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: _logo),
            borderRadius: BorderRadius.circular(100)
          ),
          onPressed: _action,
          child: FaIcon(
            FontAwesomeIcons.google,
            color: _logo,
          ),
        ),
      ],
    );
  }
}
