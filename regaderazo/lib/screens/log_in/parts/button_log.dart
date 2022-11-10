
import 'package:flutter/material.dart';

class ButtonLog extends StatelessWidget {
  const ButtonLog({
    Key? key,
    required this.context,
    required Color background,
    required Color splash,
    required Color text_color,
    required this.text,
    required this.onPressed,
  }) : _background = background, 
      _splash = splash, 
      _text = text_color, 
      super(key: key);

  final BuildContext context;
  final Color _background;
  final Color _splash;
  final Color _text;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        //vertical: 5
        horizontal: 20
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 48,
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.025),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(_background),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          padding: MaterialStateProperty.all(
            EdgeInsets.all(10),
          ),
          overlayColor:
              MaterialStateColor.resolveWith((states) => _splash),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: _text,
          ),
        ),
      ),
    );
  }
}