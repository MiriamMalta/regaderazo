import 'package:flutter/material.dart';

class HaveAccount extends StatelessWidget {
  const HaveAccount({
    Key? key,
    required Color? tertiaryColor,
    required Color secondaryColor,
    required String text1,
    required String text2,
    required Function() route,
  }) : _tertiaryColor = tertiaryColor ?? Colors.white, 
      _secondaryColor = secondaryColor, 
      _text1 = text1,
      _text2 = text2,
      _route = route,
      super(key: key);

  final Color _tertiaryColor;
  final Color _secondaryColor;
  final String _text1;
  final String _text2;
  final Function() _route;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _text1,
          style: TextStyle(
            color: _tertiaryColor,
          ),
        ),
        GestureDetector(
          onTap: _route,
          child: Text(
            _text2,
            style: TextStyle(
              color: _secondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}