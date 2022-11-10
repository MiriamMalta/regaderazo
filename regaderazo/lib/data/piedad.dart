
import 'package:flutter/material.dart';
import '../config/colors.dart';

class PiedadData {
  static const String name = 'Piedad';
  Color temp = ColorSelector.getDarkPink();

  final List<Map<String, dynamic>> _temperature = [
    {'day': 'Lun', 'temperature': 35.0,},
    {'day': 'Mar', 'temperature': 36.0,},
    {'day': 'Miérc', 'temperature': 35.0,},
    {'day': 'Juev', 'temperature': 37.0,},
    {'day': 'Vier', 'temperature': 39.0,},
    {'day': 'Sáb', 'temperature': 37.0,},
    {'day': 'Dom', 'temperature': 38.0,},
  ];
  // return temperature data
  List<Map<String, dynamic>> getTemperature() {
    return _temperature;
  }

  final List<Map<String, dynamic>> _day = [
    {'day': 'Lun', 'saving': 100.0, 'total': 120.0,},
    {'day': 'Mar', 'saving': 80.0, 'total': 120.0,},
    {'day': 'Miérc', 'saving': 80.0, 'total': 140.0,},
    {'day': 'Juev', 'saving': 90.0, 'total': 160.0,},
    {'day': 'Vier', 'saving': 110.0, 'total': 180.0,},
    {'day': 'Sáb', 'saving': 120.0, 'total': 200.0,},
    {'day': 'Dom', 'saving': 100.0, 'total': 160.0,},
  ];
  // return day data
  List<Map<String, dynamic>> getDay() {
    return _day;
  }

  final List<Map<String, dynamic>> _month = [
    {'month': 'En', 'saving': 100.0, 'total': 120.0,},
    {'month': 'Feb', 'saving': 80.0, 'total': 120.0,},
    {'month': 'Mzo', 'saving': 80.0, 'total': 140.0,},
    {'month': 'Abr', 'saving': 90.0, 'total': 160.0,},
    {'month': 'My', 'saving': 110.0, 'total': 180.0,},
    {'month': 'Jun', 'saving': 120.0, 'total': 200.0,},
    {'month': 'Jul', 'saving': 100.0, 'total': 160.0,},
    {'month': 'Ag', 'saving': 100.0, 'total': 120.0,},
    {'month': 'Sep', 'saving': 80.0, 'total': 120.0,},
    {'month': 'Oct', 'saving': 80.0, 'total': 140.0,},
    {'month': 'Nov', 'saving': 90.0, 'total': 160.0,},
    {'month': 'Dic', 'saving': 110.0, 'total': 180.0,},
  ];
  // return month data
  List<Map<String, dynamic>> getMonth() {
    return _month;
  }
}