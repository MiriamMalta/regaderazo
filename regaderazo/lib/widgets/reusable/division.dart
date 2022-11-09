import 'package:flutter/material.dart';

import '../../config/colors.dart';

class Division extends StatelessWidget {
  Division({
    Key? key,
  }) : super(key: key);

  final Color _color_thin = ColorSelector.getGrey();
  final Color _color_thick = ColorSelector.getBlack();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Divider(
              color: _color_thin,
              thickness: 2,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Divider(
              color: _color_thick,
              thickness: 3,
            ),
          ),
        ],
      ),
    );
  }
}