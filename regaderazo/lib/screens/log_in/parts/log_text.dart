
import 'package:flutter/material.dart';

class LogText extends StatelessWidget {
  
  LogText({
    Key? key,
    required this.context,
    required Color tertiaryColor,
    required Color secondaryColor,
    required this.icon,
    required this.text,
    required this.onChanged,
    required this.tailIcon,
    required this.obscure,
  }) : _tertiaryColor = tertiaryColor, _secondaryColor = secondaryColor, super(key: key);

  final BuildContext context;
  final Color _tertiaryColor;
  final Color _secondaryColor;
  final IconData icon;
  final String text;
  final ValueChanged onChanged;
  final IconData? tailIcon;
  bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        //vertical: 5, 
        horizontal: 20
      ),
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: _tertiaryColor,
        borderRadius: BorderRadius.circular(40),
      ),
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.025),
      child: TextField(
        obscureText: obscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon, 
            color: _secondaryColor,
          ),
          hintText: text,
          border: InputBorder.none,
          suffixIcon: tailIcon == null ? 
          Icon(null) : 
          IconButton(
            onPressed: (){
              obscure = !obscure;
              //setState(() {});
              print(obscure);
            },
            icon: Icon(
              tailIcon,
              color: this._secondaryColor,
              size: 20
            )
          ),
        ),
      ),
    );
  }
}

