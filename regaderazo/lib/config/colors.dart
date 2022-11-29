import 'package:flutter/material.dart';

class ColorSelector {
  // Colors
  
  static const _REGADERAZO_RED = Color.fromRGBO(248, 95, 106, 1); // #F85F6A
  static Color getRRed() {
    return _REGADERAZO_RED;
  }

  static const _REGADERAZO_BLUE = Color.fromRGBO(82, 200, 250, 1); // #52C8FA
  static Color getRBlue() {
    return _REGADERAZO_BLUE;
  }

  static const _BLACK = Color.fromRGBO(0, 0, 0, 1); //#000000
  static Color getBlack() {
    return _BLACK;
  }

  static const GREY = Color.fromRGBO(222, 226, 230, 1); //#DEE2E6
  static Color getGrey() {
    return GREY;
  }

  static const GREYISH = Color.fromRGBO(234, 232, 235, 1); //#E1D9E6 // 235, 240, 244, 1
  static Color getGreyish() {
    return GREYISH;
  }

  static const DARK_GREY = Color.fromRGBO(153, 153, 153, 1); //#999999
  static Color getDarkGrey() {
    return DARK_GREY;
  }

  static const _PURPLE = Color.fromRGBO(205, 180, 219, 1); // #cdB4db
  static Color getPurple() {
    return _PURPLE;
  }

  static const _PINK = Color.fromRGBO(255, 235, 237, 1); // #ffc8dd
  static Color getPink() {
    return _PINK;
  }

  static const _DARK_PINK = Color.fromRGBO(255, 175, 204, 1); // #ffafc
  static Color getDarkPink() {
    return _DARK_PINK;
  }

  static const _LIGHT_BLUE = Color.fromRGBO(189, 224, 254, 1); // #bde0fe
  static Color getLightBlue() {
    return _LIGHT_BLUE;
  }

  static const _DARK_BLUE = Color.fromRGBO(162, 210, 255, 1); // #a2d2ff
  static Color getDarkBlue() {
    return _DARK_BLUE;
  }

  static const List _COLORS = [
    "0xFF000000",
    "0xFFE9A0A0",
    "0xFFf08080",
    "0xFFf4978e",
    "0xFFf8ad9d",
    "0xFFfbc4ab",
    "0xFFffdab9",
    "0xFFE7D797",
    "0xFFd4e09b",
    "0xFFD0E0AC",
    "0xFFcbdfbd",
    "0xFF9EC1A3",
    "0xFF70A288",
    "0xFF79B1AA",
    "0xFF82C0CC",
    "0xFF489FB5",
    "0xFF2F8498",
    "0xFF16697A",
    "0xFF0D516C",
    "0xFF04395E",
    "0xFF314776",
    "0xFF5E548E",
    "0xFF9B90C2",
    "0xFF9F86C0",
    "0xFFA87DC2",
    "0xFFBE95C4",
    "0xFFE0B1CB",
    "0xFFE6BED4",
  ];
  static List getList() {
    return _COLORS;
  }

}
