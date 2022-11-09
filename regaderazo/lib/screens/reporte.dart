import 'package:flutter/material.dart';
import 'package:regaderazo/models/slean.dart';

import '../config/colors.dart';
import '../models/temperature.dart';
import '../widgets/reusable/spline_area.dart';
import '../widgets/reusable/column_chart.dart';
import '../widgets/reusable/division.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var data1 = [
    TemperatureChart('Lunes', 35), // , ColorSelector.getGrey()
    TemperatureChart('Martes', 36), // , ColorSelector.getPurple()
    TemperatureChart('Miércoles', 35), // , ColorSelector.getPink()
    TemperatureChart('Jueves', 37), // , ColorSelector.getDarkPink()
    TemperatureChart('Viernes', 39), // , ColorSelector.getLightBlue()
    TemperatureChart('Sábado', 37), // , ColorSelector.getDarkBlue()
    TemperatureChart('Domingo', 38), // , ColorSelector.getGreyish()
  ];

  var data2 = [
    SplineAreaData('Lunes', 100, 120),
    SplineAreaData('Martes', 80, 120),
    SplineAreaData('Miércoles', 80, 140),
    SplineAreaData('Jueves', 90, 160),
    SplineAreaData('Viernes', 110, 180),
    SplineAreaData('Sábado', 120, 200),
    SplineAreaData('Domingo', 100, 180),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            top: MediaQuery.of(context).size.width * 0.1,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){print("Home");}, icon: Icon(Icons.home), color: ColorSelector.getRed(),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Reporte', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Regaderazo'),
                  ],
                ),
                Division(),
                ColumnChart(data: data1, color: ColorSelector.getPurple()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Ahorro de Agua'),
                  ],
                ),
                Division(),
                SplineArea(data: data2, colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
                SplineArea(data: data2, colorA: ColorSelector.getLightBlue(), colorB: ColorSelector.getPink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}