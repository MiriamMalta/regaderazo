
import 'package:flutter/material.dart';

class OrLine extends StatelessWidget {
  const OrLine({
    Key? key,
    required this.context,
    required Color tertiaryColor,
  }) : _tertiaryColor = tertiaryColor, super(key: key);

  final BuildContext context;
  final Color _tertiaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: _tertiaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.05),
            child: Text(
              "  o  ",
              style: TextStyle(
                color: _tertiaryColor,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: _tertiaryColor,
            ),
          ),
        ],
      ),
    );
  }
}